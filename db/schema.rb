# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "facebook_messages", :force => true do |t|
    t.string   "session_key",       :default => "",                    :null => false
    t.string   "expires",           :default => "0",                   :null => false
    t.integer  "uid",                                                  :null => false
    t.string   "api_method",        :default => "",                    :null => false
    t.text     "params",            :default => "",                    :null => false
    t.string   "state",             :default => "new",                 :null => false
    t.datetime "send_after",        :default => '1969-12-31 17:00:00', :null => false
    t.datetime "last_send_attempt"
    t.integer  "send_attempts",     :default => 0,                     :null => false
    t.text     "facebook_errors"
    t.text     "response_xml"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_users", :force => true do |t|
    t.integer  "uid",             :null => false
    t.string   "session_key"
    t.string   "session_expires"
    t.datetime "last_access"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_users", ["uid"], :name => "index_facebook_users_on_uid", :unique => true

  create_table "facebooker_apps", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "image_url"
    t.boolean  "approved",    :default => false, :null => false
    t.integer  "uid",                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
