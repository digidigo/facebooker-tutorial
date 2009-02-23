class FacebookerApp < ActiveRecord::Base
  validates_presence_of :name, :description, :url, :image_url
end
 