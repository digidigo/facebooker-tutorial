
# Methods added to this helper will be available to all templates in the application.
require 'rubygems'
require 'coderay'

module ApplicationHelper

   def highlight_file(file, type = :ruby)
      full_file =  File.join(RAILS_ROOT,file)
      raise "CantFileFile" unless File.exists?(full_file)
      lines = "# File: #{file}\n" + File.read(full_file)
      highlight_code(lines,type)

   end

   def highlight_code(code, type = :ruby)
      tokens = CodeRay.scan(code, type)
      content_tag( :div, tokens.div(:line_numbers => :table, :css => :class).gsub(/on.*?click=".*?"/,""), :class => "code")

   end

   def highlight_method(file,method, type = :ruby)
      method_contents = ["#File: #{file} Method: #{method}\n"]
      found_method = false
      file =  File.join(RAILS_ROOT,file)
      raise "CantFileFile" unless File.exists?(file)
      begining_space = 0 
      File.read(file).each do |line|
         if(line.match(/def #{method}/))
            begining_space = line.match(/(\s*)/)[1].length
            found_method = true
            method_contents << line[begining_space..-1]
         elsif(found_method)
            if(line.match(/def/) || line.match(/^\s+#/))
               found_method = false
               break
            else
               method_contents << line[begining_space..-1]
            end
         end
      end
     
      highlight_code(method_contents.join(""), type)
   end

   def highlight_tagged(file, file_tag, type = :ruby)
      file_tag += "_TAG"
      method_contents = ["#File: #{file}\n"]
      found_method = done = false
      file =  File.join(RAILS_ROOT,file)
      raise "CantFileFile: #{file}" unless File.exists?(file)
      File.read(file).each do |line|

         if(line.match(/#{file_tag}/))

            if(found_method )
               done = true
            else
               found_method = true
            end
         elsif(found_method)
            method_contents << line unless done
         end
      end
      highlight_code(method_contents.join(""), type)
   end
   
   def highlight_controller_method(method)
     highlight_method("app/controllers/#{params[:controller]}_controller.rb", method)
   end
   
   def highlight_helper_method(file, method)
     highlight_method("app/helpers/#{file}_helper.rb", method)
   end
   
   def this_view(action = params[:action])
     "app/views/#{params[:controller]}/#{action}.fbml.erb"
   end

   def section_tab_items
      LessonOutline.outline.sections.collect do |section|
         fb_tab_item(section.name, url_for(section.lessons.first.url_options), :selected => tab_selected?(section) )
      end.join("\n")
   end

   def tab_selected?(section)
      (section.lessons.first.url_options[:controller] == params[:controller])
   end

   def scan(text, type = :ruby)

   end

   def next_lesson
      unless(@next_lesson.blank?)
         content_tag(:div, content_tag(:span, "Next Lesson &rarr; #{next_lesson_link}") , :class => 'next_lesson')
      end
   end
   
   def lesson_header(lesson)
     "#{LessonOutline.section_number(lesson)}.#{LessonOutline.lesson_number(lesson)})"
   end

   def next_lesson_link
      link_to(next_lesson_title, next_lesson_url)
   end

   def next_lesson_url
      url_for(@next_lesson.url_options)
   end

   def next_lesson_title
      @next_lesson.title
   end
   
   def google_ad
     content_tag("fb:iframe",nil ,  :scrolling => "no", :frameborder => 0 , 
       :width => 500, :height => 64, 
       :src => url_for(:controller => "ads", :action => "adsense", 
                  :canvas => false, :only_path => false))   
   end
  
   def social_media_ad
     '<fb:iframe src="http://ads.socialmedia.com/facebook/monetize.php?width=645&height=60&pubid=25ca46cdb7fcfaf642df081968a31a78" border="0" width="645" height="60" name="socialmedia_ad" scrolling="no" frameborder="0"></fb:iframe>'
   end
   
   def rotate_ad
     ad_type_methods = [:google_ad,:social_media_ad]
     ad_method = ad_type_methods[rand(ad_type_methods.length)]
     self.send(ad_method)
   end
   

   def wiki_link(api_part)
      tag = api_part
      if(api_part.match(/^fb/))
         tag = api_part.gsub(/fb_/,"Fb:").gsub(/[_]/,"-")
      end
      link_to(api_part, "http://wiki.developers.facebook.com/index.php/#{tag}", :target => "wiki_docs")
   end
   
   def approve_remove_tag(app)
     text = app.approved? ? "Delete" : "Approve"
     action_name = app.approved? ? "delete" : "approve"
     div_id = app.approved? ? "facebooker_app_#{@facebooker_app.id}" : "app_rem_#{@facebooker_app.id}"
     link_to_remote(text, :url => {:action => action_name, :id => @facebooker_app.id, :canvas => false, :only_path => false}, :update => div_id, request_forgery_protection_token.to_s => h(form_authenticity_token()))
   end
  

end
