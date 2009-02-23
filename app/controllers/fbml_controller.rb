class FbmlController < ApplicationController
   ensure_authenticated_to_facebook :only => [ :invite_friends]
   caches_page :tabs
   caches_page :invite_friends
   caches_page :comments
   def request_form
   end

   def tabs
   end

   def invite_friends
       
   end
   
   def comments
     
   end
   
   def tell_a_friend
     @title = ""
     
   end

   def self.init_outline(outline)
      section_name = "FBML"
      outline.add_lesson(section_name, "Tabs",
      {:controller => "fbml", :action => "tabs"},
      "This lesson shows you how to render a facebook tab control.")
      outline.add_lesson(section_name, "Invite Friends",
      {:controller => "fbml", :action => "invite_friends"},
      "This lesson show you how to create a control to allow a user to invite friends to do some action. The most common action is to invite users to add the application. Facebook itself handles the sending of the request to users.")
      outline.add_lesson(section_name, "Allow Comments",
      {:controller => "fbml", :action => "comments"},
      "This is cool.  Facebook has a control that allows you to put a comment area on any and every page. If you have noticed, this tutorial, has comments at the bottom of every lesson. I put it in the layout.  The cool thing about this is that all the data is stored on Facebook servers and you can be notified if someone actually comments.")
   end
end
