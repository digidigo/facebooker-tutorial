class WallController < ApplicationController    
	ensure_authenticated_to_facebook
	before_filter :setup_facebook_user
	def index
	end
end
