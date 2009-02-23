class AjaxController < ApplicationController     
	ensure_authenticated_to_facebook :except => [:test , :update_test,:update_ajax ]
	protect_from_forgery :secret => '2kdjnaLI8'
	
	def update_ajax   
		 logger.debug("Called update ajax.")  
		 render :template => "/ajax/update_ajax.fbml.erb", :layout => false
	end 
	
	def test
		
	end 
	
	def update_test
	     render :text => "Updated at #{Time.now}"
	end   
	
	private
	
	def dump_request
		 logger.debug(request.inspect)
	end
end
