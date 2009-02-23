class FormsController < ApplicationController  
	ensure_authenticated_to_facebook
	def request_form
		@facebook_user = facebook_session.user
	 
	end
end
