
module Facebooker
  
  class Session
    def self.canvas_server_base(request_params)
      if(request_params["fb_sig_network"] == "Bebo")
        "apps.bebo.com"
      else
        "apps.facebook.com"     
      end
    end 

    def self.secret_key
      ApplicationController.bebo_request? ? facebooker_config["bebo_secret_key"] : facebooker_config["secret_key"]
    end  

    def self.api_key
      ApplicationController.bebo_request? ? facebooker_config["bebo_api_key"] : facebooker_config["api_key"]
    end   
    @@facebooker_config = nil
    # We could easilty expose the config file in init.rb instead of this
    def self.facebooker_config
      
      return @@facebooker_config if @@facebooker_config
    
      facebook_config_file = "#{RAILS_ROOT}/config/facebooker.yml"

      if File.exist?(facebook_config_file)
        @@facebooker_config = YAML.load_file(facebook_config_file)[RAILS_ENV]     
      end
    end
  end
  
  class BeboSession < Session
    API_SERVER_BASE_URL       = 'apps.bebo.com' 
    API_PATH_REST             = "/restserver.php"
    WWW_SERVER_BASE_URL       = 'www.bebo.com' 
    WWW_PATH_LOGIN            = 'SignIn.jsp' 
    WWW_PATH_ADD              = "add.php"
    WWW_PATH_INSTALL          = '/c/apps/add' 
    WWW_CANVAS_SERVER_BASE = "apps.bebo.com" 
   
    
    def server
      "www.bebo.com"
    end
    
    def service
      @service ||= Service.new(API_SERVER_BASE_URL, API_PATH_REST, @api_key)      
    end
    
    def login_url(options={})
      options = default_login_url_options.merge(options)
      "http://#{server}/#{WWW_PATH_LOGIN}?ApiKey=#{@api_key}&v=1.0#{login_url_optional_parameters(options)}&next=/admin/master_redirect"
    end

    def install_url(options={})
      "http://#{server}/#{WWW_PATH_INSTALL}?ApiKey=#{@api_key}&v=1.0#{install_url_optional_parameters(options)}"
    end
  end 
end


class ApplicationController < ActionController::Base  
  
  # Overide the session create so that we can override the above methods
  # This won't be necessary if we abstract install url api server url , api path rest 
  def new_facebook_session
    if(ApplicationController.bebo_request?)             
      Facebooker::BeboSession.create(Facebooker::BeboSession.api_key, Facebooker::BeboSession.secret_key)
    else
      Facebooker::Session.create(Facebooker::Session.api_key, Facebooker::Session.secret_key)
    end
  end
  
  # Setup bebo context.  Itried a prepend before filter here but it didn't work.
  def set_facebook_session
    set_application_context
    super
  end

  #  Expose from the class level contenxt whether we are in a bebo request or not.
  def set_application_context
    @@bebo = params[:fb_sig_network] == 'Bebo'
  end
  
  def self.bebo_request?
    @@bebo
  end
  
  def self.facebook_request?
    !@@bebo
  end
end

module ::ActionController
  
  class UrlRewriter
    # I duped this whole method when all we need to do is abstract canvas_server_base url
    def rewrite_url_with_facebooker(*args)
      options = args.first.is_a?(Hash) ? args.first : args.last
      is_link_to_canvas = link_to_canvas?(@request.request_parameters, options)
      if is_link_to_canvas && !options.has_key?(:host)
        options[:host] = Facebooker::Session.canvas_server_base(@request.request_parameters)
      end 
      options.delete(:canvas)
      Facebooker.request_for_canvas(is_link_to_canvas) do
        rewrite_url_without_facebooker(*args)
      end
    end
  end
end
