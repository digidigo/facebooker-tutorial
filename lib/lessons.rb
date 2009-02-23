class Lesson
	 attr_accessor :title, :url_options, :purpose
	 
	 def initialize(title, url_options,purpose)
		  self.title = title
		  self.url_options = url_options  
		  self.purpose = purpose
	 end
end 

class LessonSection
	 attr_accessor :name, :lessons 
	
	 def add_lesson(title, url_options,purpose)
		   self.lessons ||= []
		   self.lessons << Lesson.new(title, url_options,purpose)
	 end  
	
	def initialize(name)
		  self.name = name
	 end
end  

class LessonOutline
	 attr_accessor :sections  
	 
	 def self.outline
		  @@outline ||= LessonOutline.new
	 end
         

	 def add_lesson(section_name, title, url_options, purpose)
		  self.sections ||= []
		  
		  section = sections.detect{|section| section.name == section_name}  || LessonSection.new(section_name)
			section.add_lesson(title, url_options,purpose) 
			self.sections << section unless self.sections.include?(section)
		  
	 end    
	
	 def flat_lessons
		  @flat_lessons ||= sections.map(&:lessons).flatten
	 end
         
         def self.lesson_number(lesson)
           outline.lesson_number(lesson)
         end
         
         def lesson_number(lesson)
           ( sections[section_number(lesson) - 1].lessons.index(lesson) + 1) rescue 0
         end
         def self.section_number(lesson)
           outline.section_number(lesson)
         end
         def section_number(lesson)
           section = sections.each_with_index{|section, index|
             return (index + 1) if( section.lessons.include? lesson )
           }
           return 0
         end
	
	 def get_previous_current_next_lesson(url_options) 
		
		  previous_lesson = current_lesson = next_lesson = nil
		
		  self.sections.each_with_index do |section, section_index|    			
			   section.lessons.each_with_index do |lesson, lesson_index| 
				     				
				     if(equivilant(lesson.url_options, url_options))
					      current_lesson = lesson	
								 current_lesson_index = flat_lessons.index(current_lesson)
								 next_lesson = flat_lessons[current_lesson_index + 1]
							   if(flat_lessons.first == current_lesson)
								   previous_lesson = nil
								 else
									 previous_lesson = flat_lessons[current_lesson_index - 1]
								 end				      
					   end 
					  
				 end 
			end  
			
			return previous_lesson, current_lesson ,next_lesson
	 end 
	
	 def equivilant(a,b)
		   a.each do |k,v|
			    equal =  a[k].to_s.strip == b[k].to_s.strip
			    if(!equal)
				      return false
				  end
			 end       
			
			 return true
	 end
	
end 


outline = LessonOutline.outline

controllers = [GettingStartedController, FbmlController, MessagingController, AdsController]

controllers.each do |controller|
	  controller.send(:init_outline, outline)
end
