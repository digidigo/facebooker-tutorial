class CreateFacebookerApps < ActiveRecord::Migration
  def self.up
    create_table :facebooker_apps do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :image_url
      t.boolean :approved, :null => false, :default => false
      t.integer :uid, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :facebooker_apps
  end
end
