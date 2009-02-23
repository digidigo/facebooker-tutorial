module GettingStartedHelper 
	
	def show_session_data
		 facebooker_session = @facebook_session.clone
		 facebooker_session.instance_variable_set("@secret_key",'xxxxxxxxxxxxxxxxxxx')
		 facebooker_session.to_yaml
	end 
	
	def show_user_data
		 "FOO"
	end
	
	def noop
		
	end
end
