class ConditionalsController < ApplicationController 
	ensure_authenticated_to_facebook :except => :index  
  before_filter	:setup_facebook_user
	def index
		
	end
	
	def added_app
		 render :action => "index"
	end  
	
	def you
		 @check_user = @facebook_user
	end
	
	def friend
		 @check_user = @facebook_user.friends.first  
		 render :action => "you"
	end
end
