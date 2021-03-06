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

ActiveRecord::Schema.define(:version => 20130304234838) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "published"
    t.string   "image_url"
    t.integer  "views"
  end

  add_index "articles", ["author_id"], :name => "index_articles_on_author_id"

  create_table "awards", :force => true do |t|
    t.string   "name"
    t.integer  "competition_id"
    t.integer  "importance"
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "icon_url"
    t.string   "inline_icon_url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "owner_id",         :null => false
    t.integer  "commentable_id",   :null => false
    t.string   "commentable_type", :null => false
    t.text     "body",             :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "competition_entries", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "competition_entries", ["competition_id"], :name => "index_competition_entries_on_competition_id"
  add_index "competition_entries", ["team_id"], :name => "index_competition_entries_on_team_id"

  create_table "competition_judges", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "competition_maps", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "map_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "competition_optional_maps", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "map_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "competitions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "parent_competition_id"
    t.datetime "signup_ends"
    t.text     "team_stats_config"
    t.datetime "starts"
    t.datetime "ends"
    t.text     "regulations"
    t.integer  "season"
    t.string   "status"
    t.string   "challonge_module_url"
    t.boolean  "score_counted",         :default => false
    t.boolean  "kills_counted",         :default => true
    t.boolean  "deaths_counted",        :default => true
    t.boolean  "assists_counted",       :default => true
    t.string   "score_base",            :default => "kills"
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "match_entries", :force => true do |t|
    t.integer  "match_map_id"
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "score"
    t.integer  "kills"
    t.integer  "deaths"
    t.integer  "assists"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "match_entries", ["team_id"], :name => "index_match_entries_on_team_id"
  add_index "match_entries", ["user_id"], :name => "index_match_entries_on_user_id"

  create_table "match_map_images", :force => true do |t|
    t.integer  "match_map_id"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "match_maps", :force => true do |t|
    t.integer  "match_id"
    t.integer  "map_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "match_maps", ["map_id"], :name => "index_match_maps_on_map_id"
  add_index "match_maps", ["match_id"], :name => "index_match_maps_on_match_id"

  create_table "match_time_proposals", :force => true do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.datetime "proposal"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "active"
  end

  add_index "match_time_proposals", ["match_id"], :name => "index_match_time_proposals_on_match_id"
  add_index "match_time_proposals", ["team_id"], :name => "index_match_time_proposals_on_team_id"

  create_table "matches", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.datetime "scheduled_at"
    t.integer  "judge_id"
    t.boolean  "processed"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "locked_by_judge"
    t.integer  "round_id"
    t.integer  "forfeiting_team_id"
    t.string   "not_played_comment"
  end

  add_index "matches", ["competition_id"], :name => "index_matches_on_competition_id"

  create_table "offers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.boolean  "originated_from_player"
    t.boolean  "open"
    t.boolean  "accepted"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.text     "content"
  end

  add_index "offers", ["team_id"], :name => "index_offers_on_team_id"
  add_index "offers", ["user_id"], :name => "index_offers_on_user_id"

  create_table "rounds", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "number"
    t.datetime "starts"
    t.datetime "ends"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "round_name"
  end

  add_index "rounds", ["competition_id"], :name => "index_rounds_on_competition_id"

  create_table "team_participations", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "active"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "tag"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "psn_name"
    t.string   "authentication_token"
    t.boolean  "banned",                                :default => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
