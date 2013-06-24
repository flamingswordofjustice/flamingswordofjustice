# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130619214214) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "appearances", :force => true do |t|
    t.text     "description"
    t.integer  "guest_id"
    t.string   "guest_type"
    t.integer  "episode_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "emails", :force => true do |t|
    t.string   "subject"
    t.string   "sender"
    t.string   "recipient"
    t.integer  "episode_id"
    t.text     "body"
    t.text     "header_note"
    t.datetime "sent_at"
    t.datetime "proofed_at"
    t.integer  "proofed_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "episodes", :force => true do |t|
    t.string   "title"
    t.string   "download_url"
    t.text     "description"
    t.boolean  "published"
    t.datetime "published_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "slug"
    t.string   "image"
    t.string   "number"
    t.string   "libsyn_id"
    t.string   "headline"
    t.string   "state"
    t.text     "social_description"
    t.text     "show_notes"
    t.string   "image_caption"
    t.string   "twitter_text"
    t.integer  "redirect_id"
    t.datetime "email_proofed_at"
    t.integer  "email_proofed_by_id"
    t.text     "email_note"
    t.text     "filepicker_images"
    t.string   "share_progress_code"
    t.integer  "host_id"
    t.string   "youtube_video_id"
  end

  add_index "episodes", ["slug"], :name => "index_shows_on_slug", :unique => true
  add_index "episodes", ["state"], :name => "index_episodes_on_state"

  create_table "navigation_links", :force => true do |t|
    t.string  "title"
    t.string  "location"
    t.integer "parent_link_id"
    t.integer "page_id"
    t.integer "position"
    t.integer "linkable_id"
    t.string  "linkable_type"
  end

  add_index "navigation_links", ["linkable_id", "linkable_type"], :name => "index_navigation_links_on_linkable_id_and_linkable_type"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.text     "description"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "image"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "slug"
    t.string   "short_description"
    t.integer  "appearances_count", :default => 0
  end

  add_index "organizations", ["slug"], :name => "index_organizations_on_slug", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

  create_table "people", :force => true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.text     "description"
    t.string   "website"
    t.string   "twitter"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "image"
    t.string   "facebook"
    t.string   "slug"
    t.string   "title"
    t.string   "email"
    t.string   "public_email"
    t.integer  "appearances_count", :default => 0
  end

  add_index "people", ["appearances_count"], :name => "index_people_on_appearances_count"
  add_index "people", ["slug"], :name => "index_guests_on_slug", :unique => true

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "redirects", :force => true do |t|
    t.string  "path",                         :null => false
    t.string  "destination",                  :null => false
    t.integer "hits",          :default => 0
    t.text    "notes"
    t.integer "linkable_id"
    t.string  "linkable_type"
  end

  add_index "redirects", ["linkable_id", "linkable_type"], :name => "index_redirects_on_linkable_id_and_linkable_type"
  add_index "redirects", ["path"], :name => "index_redirects_on_path", :unique => true

  create_table "subscribers", :force => true do |t|
    t.string   "email"
    t.datetime "confirmed_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "topic_assignments", :force => true do |t|
    t.integer "topic_id"
    t.integer "assignable_id"
    t.string  "assignable_type"
  end

  add_index "topic_assignments", ["assignable_id", "assignable_type"], :name => "index_topic_assignments_on_assignable_id_and_assignable_type"

  create_table "topics", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.string "image"
    t.string "slug"
  end

  add_index "topics", ["slug"], :name => "index_topics_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "name",                   :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "image"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
