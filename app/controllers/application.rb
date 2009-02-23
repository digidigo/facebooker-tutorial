# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  
  helper :all # include all helpers, all the time
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => '4d961c3ce4cffca315ed3c696e26fffd'
  before_filter :setup_lessons

  # SAVE_URL_FOR_ADD_AND_LOGIN_TAG
  before_filter :redirect_if_auth_key, :except => "master_redirect"
  
  
  def redirect_if_auth_key
    if( params[:auth_token])
      redirect_to( url_for(:controller => "admin", :action => "master_redirect", :canvas => true, :only_path => false))
      return false
    else
      cookies[:last_request] = url_for(:controller => params[:controller], :action => params[:action], :only_path => false, :canvas => true)
      return true
    end
  end   

  def application_is_not_installed_by_facebook_user
    redirect_to session[:facebook_session].install_url(:next => next_path() )
  end
  
  
  def next_path
    path = "/#{params[:controller]}/#{params[:action]}?"
    non_keys = ["controller", "method", "action","format", "_method", "auth_token"]
    params.each do |k,v|
      next if non_keys.include?(k.to_s) || k.to_s.match(/^fb/)  
      path += "#{k}=#{v}&"
    end

    path
     
  end
  
  # This filter will handle the redirect after a user logs into the app as well as save
  # The previous url in the session.  The redirect goes to the master_redirect action
  # since we don't have a session here.
  after_filter :setup_db_facebook_user
  
  # SAVE_URL_FOR_ADD_AND_LOGIN_TAG
   
  # REDIRECT_TO_LAST_REQUEST_TAG
  before_filter :redirect_to_saved, :only => "master_redirect"
   
  def redirect_to_saved
    redirect_to( cookies[:last_request] || url_for("/")) and return false
  end  
  # REDIRECT_TO_LAST_REQUEST_TAG
   
  def setup_facebook_user
    @facebook_user = facebook_session.user
    @facebook_user.populate
  end

  def purpose(purpose)
    @purpose = purpose
  end

  def setup_lessons
    @previous_lesson, @current_lesson, @next_lesson = LessonOutline.outline.get_previous_current_next_lesson(:controller => params[:controller], :action => params[:action])
  end
   
  def self.wiki_link(api_part)
    tag = api_part
    if(api_part.match(/^fb/))
      tag = api_part.gsub(/fb_/,"Fb:").gsub(/[_]/,"-")
    end
    link_to(api_part, "http://wiki.developers.facebook.com/index.php/#{tag}", :target => "wiki_docs")
  end
   
  def wiki_link(api_part)
    self.class.wiki_link(api_part)
  end
      
  def self.link_to(text,path, options = {})       
    "<a href='#{path}' #{options.collect{|key,value| "#{key}='#{value}'"  }.join(" ") } >#{text}</a>"
  end
      
  def link_to(text, path, options = {})
    path = url_for(path) unless String === path
    self.class.link_to(text,path, options)      
  end
  
  def setup_db_facebook_user
    # Grab the facebook user if we have one and store it in the session
    unless( @fb_user || @facebook_session.nil? || facebook_params.empty?  )

      user_id =  facebook_params["user"]
      session_key = facebook_params["session_key"]
      expires =     facebook_params["expires"]
      
      return if(user_id.blank?)
      fb_user = FacebookUser.ensure_create_user(user_id)
      if( fb_user.session_key != session_key )
        fb_user.session_key = session_key
        fb_user.session_expires = expires
             FacebookerPublisher.deliver_profile_for_user( facebook_session.user ) if facebook_session
        fb_user.save!
      elsif(fb_user.last_access.nil?  || fb_user.last_access < (Time.now - 1.days) )
          FacebookerPublisher.deliver_profile_for_user( facebook_session.user ) if facebook_session
        fb_user.last_access = Time.now
        fb_user.save!
      end
      @fb_user = fb_user
      session[:current_user] = @fb_user
      return @fb_user
    end
    return true
  end
  
  def current_user
    @fb_user
  end
  
   helper_attr :owns_app, :is_admin
   def owns_app(app)
     return( app.uid == session[:facebook_session].user.id rescue false)
   end
   
   def is_admin()
     session[:facebook_session].user.id == 830904376 rescue false
   end
end




require 'lessons'
#require_dependency 'bebo_adapter.rb'

