class GettingStartedController < ApplicationController   
	
  # ENSURE_TAG
  ensure_application_is_installed_by_facebook_user [:only => "action_that_requires_installation"]
  #ENSURE_TAG
  ensure_authenticated_to_facebook [:except => ["add_facebook_application", "log_api_calls"]]
         
	 before_filter :setup_facebook_user, :except => ["add_facebook_application", "log_api_calls"]  
	 	
	 caches_page :add_facebook_application
         caches_page :log_api_calls 
        
	 def add_facebook_application  
	 end   
	
	def user_logs_in_to_facebook 
	    setup_session    	
	end   
	
	def look_at_user_data
		  setup_session
		  setup_facebook_user
	end 
        
        def user_adds_application
           redirect_to :action => "action_that_requires_installation"
        end
        
        def action_that_requires_installation
            render :action => "user_adds_application"
        end 

        def log_api_calls
          
        end        

        def user_has_added_application
            redirect_to(:action => "user_adds_application")
        end        
	
	def self.init_outline(outline)
		   section_name = "Getting Started"
		   outline.add_lesson(section_name, "Getting Started", 
														{:controller => "getting_started", :action => "add_facebook_application"},
														"The purpose of this tutorial is to explain many aspects of the <a href='http://rubyforge.org/projects/facebooker/'>Facebooker</a> project.
														The general approach here is provide running live code to be used as a reference for you own implementation. All the code samples in this tutorial are from the actual live code running the application.  The facebooker plugin is pulled in as an external as well so the tutorial should be up to date with the latest code. ") 
		   outline.add_lesson(section_name, "Make User Login", 
														{:controller => "getting_started", :action => "user_logs_in_to_facebook"},
														 "This lesson explains how to make the user login to your application. <br>And then we look into some of the session data available to us.")
		   outline.add_lesson(section_name, "Explore Facebook User Data",
		 												{:controller => "getting_started", :action => "look_at_user_data"},
		                        " Now that we have authenticated and have a Facebooker::Session we can look at some things about the logged in user.")
                                      
                   outline.add_lesson(section_name, "Make User Add Application", {:controller => "getting_started", :action => :action_that_requires_installation}, " This lesson shows how to require that the user adds the application. After adding the application we can test if the user has added it.")
                   outline.add_lesson(section_name, "Log API Calls", {:controller => "getting_started", :action => :log_api_calls}, " This lesson shows how to monkey patch Facebooker so that you can see the API calls being made in your log file.")
	end
	
	private 
	
	def setup_session
		  @current_facebook_session = facebook_session	
	end 
	
	def setup_facebook_user
		 @current_facebook_user = facebook_session.user
	end 

  def no_op
    
  
  end        
	
end
