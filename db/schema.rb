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

ActiveRecord::Schema.define(:version => 20111226230551) do

  create_table "activities", :force => true do |t|
    t.string    "title"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "description"
    t.timestamp "starts_at"
    t.timestamp "ends_at"
    t.string    "location"
  end

  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "comments", :force => true do |t|
    t.text      "content"
    t.integer   "user_id"
    t.integer   "activity_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.boolean   "confirmed",  :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "user_id"
    t.integer   "friend_id"
  end

  create_table "participations", :force => true do |t|
    t.integer   "user_id"
    t.integer   "activity_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer   "follower_id"
    t.integer   "followed_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string    "name"
    t.string    "email"
    t.string    "location"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "encrypted_password"
    t.string    "salt"
    t.boolean   "admin",                 :default => false
    t.string    "facebook_id"
    t.boolean   "friend_notification"
    t.boolean   "activity_notification"
    t.boolean   "comment_notification"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
