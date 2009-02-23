# CLASS_CREATE_TAG
class FacebookerPublisher < Facebooker::Rails::Publisher
  
    # CLASS_CREATE_TAG
    
    # Action is published using the session of the from user
    def mini_feed(user)
      send_as :action
      self.from( user)
      title "just learned how to send a Mini-Feed Story using Facebooker."
      body "#{fb_name(user)} just checked out the #{link_to("Facebooker Tutorial", :controller => "messaging", :action => "mini_feed")} Mini-Feed lesson."
      image_1(image_path("fbtt.png"))
      image_1_link(outline_path(:only_path => false))
      RAILS_DEFAULT_LOGGER.debug("Sending mini feed story for user #{user.id}")
    end

    # Templatized Action uses From
    def templatized_news_feed(user)
      send_as :templatized_action
      from(user)
      title_template "{actor} is learning how to send News Feed items to friends."
      title_data(Hash.new())
      body_template("Be sure to check out the new #{link_to("Publisher API", outline_path(:only_path => false))} from {name}. ")
      body_general("#{link_to("Facebooker", "http://facebooker.rubyforge.org")} is a ruby implementation of the Facebook API.")
      body_data(:name => "Facebooker")
      image_1(image_path("fbtt.png"))
      image_1_link(outline_path(:only_path => false))
      
    end
    # story is published to the news feed of the to user
    def news_feed(recipients, title, body)
      send_as :story
      self.recipients(Array(recipients))
      title = title[0..60] if title.length > 60
      body = body[0..200] if body.length > 200
      self.body( body )
      self.title( title )
      image_1(image_path("fbtt.png"))
      image_1_link(outline_path(:only_path => false))
    end

    def notification(to,from,message)
      send_as :notification
      self.recipients(to)
      self.from(from)
      fbml message
    end

    def email(from,to, title, text, html)
      send_as :email
      recipients(to)
      from(from)
      title(title)
      fbml(html)
      text(text)
    end
    
       def profile_for_user(user_to_update)
           send_as :profile
           from user_to_update
           recipients user_to_update
           fbml = render(:partial =>"/messaging/user_profile.fbml.erb")
           profile(fbml)
           action =  render(:partial => "messaging/profile_action.fbml.erb") 
           profile_action(action) 
       end
    
    def logger
      
      RAILS_DEFAULT_LOGGER
    end
  end
