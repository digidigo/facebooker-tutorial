
class FacebookUser < ActiveRecord::Base

  # Don't trust facebook to send a single request to you that 
  # Initiates the creation of a row in the DB
  # This code ensures that you only get one row and that you don't
  # Get an exception
  def self.ensure_create_user(uid)
    user = nil
    begin
      user = self.find_or_initialize_by_uid(uid)
      if(user.new_record?)
        user.save!
      end
    rescue
      user = self.find_or_initialize_by_uid(uid)
      if(user.new_record?)
        user.save!
      end
    end
    raise "DidntCreateFBUser" unless user
    return user
     
  end

  
end
