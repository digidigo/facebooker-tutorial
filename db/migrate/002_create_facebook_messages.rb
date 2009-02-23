class CreateFacebookMessages < ActiveRecord::Migration
   def self.up
      create_table :facebook_messages do |t|
         t.column(:session_key, :string, :null => false) 
         t.column(:expires, :string, :null => false, :default => "0")
         t.column(:uid, :integer, :null => false)  
         t.column(:api_method, :string, :null => false)
         t.column(:params, :text, :null => false )	 # Always a hash.
         t.column(:state, :string, :null => false, :default => 'new' )
         t.column(:send_after, :datetime, :null => false, :default => Time.at(0))  # Optional date time to wait until you send
         t.column( :last_send_attempt, :datetime  )
         t.column( :send_attempts, :integer, :default => 0 , :null => false  )
         t.column( :facebook_errors, :text, :default => "")
         t.column( :response_xml, :text, :default => "")
         t.timestamps
      end
   end

   def self.down
      drop_table :facebook_messages
   end
end        
