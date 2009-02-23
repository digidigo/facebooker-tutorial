class MessagingController < ApplicationController
ensure_application_is_installed_by_facebook_user :only => [:test_templatized_news_feed, :test_mini_feed, :test_news_feed, :test_notification, :test_email, :test_profile]
caches_page :mini_feed
caches_page :news_feed
caches_page :templatized_news_feed
caches_page :notification
caches_page :email
caches_page :profile

  def mini_feed
  end

  def news_feed
  end

  def email
  end
  
  def notification
    set_facebook_session rescue nil
  end
  
  def templatized_news_feed
    
  end
  
  def profile
    
  end
  
  def test_templatized_news_feed
    FacebookerPublisher.deliver_templatized_news_feed(facebook_session.user)
    flash[:notice] = "Check your News Feed in a little while. You should might see a news item from Facebooker Tutorial."
    redirect_to(:action => "templatized_news_feed")
  end
  
  def test_mini_feed
      FacebookerPublisher.deliver_mini_feed(facebook_session.user)
      flash[:notice] = "Check your Mini-Feed in a little while. You should see a news item from Facebooker."
      redirect_to(:action => "mini_feed")
  end
  
  def test_news_feed
       FacebookerPublisher.deliver_news_feed(facebook_session.user, " A reminder from Facebooker Tutorial ", 
         " Keep checking at #{link_to("Facebooker Tutorial", outline_path(:only_path => false))} as we are adding new lessons every week.")
       flash[:notice] = "Check your News Feed in a little while. You should might see a news item from Facebooker Tutorial."
       redirect_to(:action => "news_feed")
  end

  def test_notification
       FacebookerPublisher.deliver_notification(facebook_session.user, facebook_session.user, 
         ", you sent a notificaiton to yourself from the #{link_to("Facebooker Tutorial", outline_path(:only_path =>false))} application. ")
       flash[:notice] = "Check your notifications in a little while."
       redirect_to(:action => "notification")
  end
  
  def test_email
      shell_email = FacebookShell.create_shell(facebook_session.user)
      text = html = nil
      shell_email.parts.each do |part|
        text = part.body  if(part.header['content-type'].to_s.match(/plain/))
        html = part.body  if(part.header['content-type'].to_s.match(/html/))
      end
      FacebookerPublisher.deliver_email(facebook_session.user, facebook_session.user, shell_email.subject, text, html)
       flash[:notice] = "Check your email in a little while. You should have an email from yourself , through Facebook."
       redirect_to(:action => "email")
  end
  
  def test_profile
     FacebookerPublisher.deliver_profile_for_user(facebook_session.user)
     flash[:notice] = "Check your profile. It should be updated."
     redirect_to(:action => "profile")
  end
  
  	def self.init_outline(outline)
          section_name = "Publisher"
          outline.add_lesson(section_name, "Mini Feed", {:controller => "messaging", :action => "mini_feed"},
             " This lesson covers the Facebooker Publisher Api and shows how to send a message to a user's Mini-Feed.  
                When you publish a story to the Mini-Feed, there is also a chance that the story will be published to 
                friends of that user that have also added the app. See #{wiki_link("Feed.publishActionOfUser")} for more details.") 
          outline.add_lesson(section_name, "News Feed", {:controller => "messaging", :action => "news_feed"},
             " This lesson shows how to use the Facebooker Publisher API to publish to a users News Feed.  
               Check out Facebook wiki for details at #{wiki_link("Feed.publishStoryToUser")}  ") 
          
           outline.add_lesson(section_name, "Templatized Action", {:controller => "messaging", :action => "templatized_news_feed"},
             " This lesson shows how to use the Facebooker Publisher API to publish a story to a users News Feed and possibly to the user's friends News Feeds.  
               Check out Facebook wiki for details at #{wiki_link("Feed.publishTemplatizedAction")}  ") 
              outline.add_lesson(section_name, "Notifications", {:controller => "messaging", :action => "notification"},
             " This lesson shows how to use the Facebooker Publisher API to publish a notification to a set of users. Notifications are controlled by 
               spam control for non-app users and app users can elect to not allow notifications from your app.    
               Check out Facebook wiki for details at #{wiki_link("Notifications.send")}  ") 
          
                    outline.add_lesson(section_name, "Emails", {:controller => "messaging", :action => "email"},
             " This lesson shows how to use the Facebooker Publisher API to publish an Email to a set of users. You can send five (5) emails to a user per day and
all the recipients must have added the application.    
               Check out Facebook wiki for details at #{wiki_link("Notifications.sendEmail")}  ") 
          
           
                    outline.add_lesson(section_name, "Profile", {:controller => "messaging", :action => "profile"},
             " This lesson shows how to use the Facebooker Publisher API to publish fbml to a user's profile. The cool thing about this approach is that the Publisher API gives you access to partials.    
               Check out Facebook wiki for details at #{wiki_link("Profile.setFBML")}  ") 
	end
end
