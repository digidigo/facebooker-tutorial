class AdminController < ApplicationController
	caches_page :outline, :feedback
	def outline
	   @title = "Tutorial Outline"
	end
        
        def feedback
          @title = "Feedback"         
        end
        
        def gallery
          @title = "Facebooker Gallery"
          @applications = FacebookerApp.find(:all, :conditions => ["approved = ?", true])
          @application = FacebookerApp.new
        end
end
