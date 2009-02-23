
#MONKEY_PATCH_TAG
module Facebooker
  class Service   
    def post_with_api_logging(params)  
      unless(RAILS_ENV == "production")
        RAILS_DEFAULT_LOGGER.debug(" Posting to #{url} #{params.inspect} ")
      end
      return post_without_api_logging(params)     
    end
    alias_method_chain :post, :api_logging
  end
   
  class Parser
    class <<self
       
      def parse_with_logging(api_method,response)
        unless(RAILS_ENV == "production")
          RAILS_DEFAULT_LOGGER.debug(" Return value #{response.body}")
        end
        return parse_without_logging(api_method, response)     
      end
      alias_method_chain :parse, :logging
    end
  end
end
#MONKEY_PATCH_TAG

 
module Facebooker
  class User
    class Status
      def to_s
        message
      end
    end
  end
   
  class Location
    def to_s
      "#{city} #{state} #{zip} #{country}"
    end
  end
   
  class EducationInfo
    class HighschoolInfo
      def to_s
        "#{hs1_name}, #{hs2_name} -- #{grad_year}"
      end
    end
    
    def to_s
      "#{name} #{year} #{degree} #{concentrations.join(",")}"
    end
  end
  
  class Affiliation
    def to_s
      "#{name} #{type} #{year}"
    end
  end
end

