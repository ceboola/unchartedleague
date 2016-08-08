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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.string   "image_url"
    t.integer  "views"
  end

  create_table "awards", :force => true do |t|
    t.string   "name"
    t.integer  "competition_id"
    t.integer  "importance"
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "icon_url"
    t.string   "inline_icon_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "owner_id",         :null => false
    t.integer  "commentable_id",   :null => false
    t.string   "commentable_type", :null => false
    t.text     "body",             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competition_entries", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competition_judges", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competition_maps", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competition_optional_maps", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competitions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_entries", :force => true do |t|
    t.integer  "match_map_id"
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "score"
    t.integer  "kills"
    t.integer  "deaths"
    t.integer  "assists"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_map_images", :force => true do |t|
    t.integer  "match_map_id"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_maps", :force => true do |t|
    t.integer  "match_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_time_proposals", :force => true do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.datetime "proposal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "matches", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.datetime "scheduled_at"
    t.integer  "judge_id"
    t.boolean  "processed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "locked_by_judge"
    t.integer  "round_id"
    t.integer  "forfeiting_team_id"
    t.string   "not_played_comment"
  end

  create_table "offers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.boolean  "originated_from_player"
    t.boolean  "open"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
  end

  create_table "rounds", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "number"
    t.datetime "starts"
    t.datetime "ends"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "round_name"
  end

  create_table "team_participations", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "psn_name"
    t.string   "authentication_token"
    t.boolean  "banned",                                :default => false
  end

end
