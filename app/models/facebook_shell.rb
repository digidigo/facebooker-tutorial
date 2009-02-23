class FacebookShell < ActionMailer::Base
  
  def shell(facebook_user)
     @subject = "Test email from Facebooker::Rails::Publisher"
     @body['user_name'] = facebook_user.name
    
  end
end
