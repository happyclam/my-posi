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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140218131119) do

  create_table "candlesticks", force: :cascade do |t|
    t.date     "tradingday"
    t.integer  "timezone"
    t.integer  "openvalue"
    t.integer  "highvalue"
    t.integer  "lowvalue"
    t.integer  "closevalue"
    t.integer  "dealings"
    t.integer  "salesvalue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "candlesticks", ["tradingday", "timezone"], name: "index_candlesticks_on_tradingday_and_timezone", unique: true

  create_table "positions", force: :cascade do |t|
    t.integer  "distinct"
    t.integer  "sale"
    t.integer  "exercise"
    t.date     "expiration"
    t.float    "maturity"
    t.integer  "number"
    t.decimal  "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "strategy_id"
  end

  add_index "positions", ["strategy_id"], name: "index_positions_on_strategy_id"

  create_table "strategies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "draw_type"
    t.integer  "range"
    t.float    "interest"
    t.float    "sigma"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "strategies", ["user_id"], name: "index_strategies_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "provider",    limit: 255
    t.string   "screen_name", limit: 255
    t.string   "uid",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["screen_name"], name: "index_users_on_screen_name", unique: true

end
