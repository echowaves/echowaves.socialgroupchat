# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110507000853) do

  create_table "convos", :force => true do |t|
    t.string   "title",         :limit => 140,                :null => false
    t.integer  "privacy_level",                :default => 0, :null => false
    t.integer  "owner_id",                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "convos", ["created_at"], :name => "index_convos_on_created_at"
  add_index "convos", ["owner_id"], :name => "index_convos_on_owner_id"
  add_index "convos", ["privacy_level"], :name => "index_convos_on_privacy_level"

  create_table "followerships", :force => true do |t|
    t.integer  "leader_id",   :null => false
    t.integer  "follower_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followerships", ["created_at"], :name => "index_followerships_on_created_at"
  add_index "followerships", ["follower_id"], :name => "index_followerships_on_follower_id"
  add_index "followerships", ["leader_id"], :name => "index_followerships_on_leader_id"

  create_table "invitations", :force => true do |t|
    t.integer  "convo_id",     :null => false
    t.integer  "user_id",      :null => false
    t.integer  "requestor_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["convo_id"], :name => "index_invitations_on_convo_id"
  add_index "invitations", ["created_at"], :name => "index_invitations_on_created_at"
  add_index "invitations", ["requestor_id"], :name => "index_invitations_on_requestor_id"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "uuid",                         :null => false
    t.string   "body",       :limit => 256000, :null => false
    t.integer  "owner_id",                     :null => false
    t.integer  "convo_id",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["convo_id"], :name => "index_messages_on_convo_id"
  add_index "messages", ["created_at"], :name => "index_messages_on_created_at"
  add_index "messages", ["owner_id"], :name => "index_messages_on_owner_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.integer  "convo_id",                            :null => false
    t.integer  "last_read_message_id", :default => 0, :null => false
    t.integer  "new_messages_count",   :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["convo_id"], :name => "index_subscriptions_on_convo_id"
  add_index "subscriptions", ["created_at"], :name => "index_subscriptions_on_created_at"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username",             :limit => 128
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "visits", :force => true do |t|
    t.integer  "user_id",                     :null => false
    t.integer  "convo_id",                    :null => false
    t.integer  "visits_count", :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visits", ["convo_id"], :name => "index_visits_on_convo_id"
  add_index "visits", ["created_at"], :name => "index_visits_on_created_at"
  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"

end
