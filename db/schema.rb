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

ActiveRecord::Schema.define(version: 20140319153827) do

  create_table "as", force: true do |t|
    t.integer "x"
    t.integer "y"
  end

  create_table "bs", force: true do |t|
    t.integer "x"
    t.integer "y"
  end

  create_table "calculators", force: true do |t|
    t.string "guid"
    t.float  "accumulator"
    t.string "current_entry"
    t.string "current_operation"
  end

  create_table "cs", force: true do |t|
    t.integer "b_id"
    t.integer "x"
    t.integer "y"
  end

  create_table "ds", force: true do |t|
    t.integer "c_id"
    t.integer "e_id"
    t.integer "x"
    t.integer "y"
  end

  create_table "es", force: true do |t|
    t.integer "x"
    t.integer "y"
  end

  create_table "memory_locations", force: true do |t|
    t.integer "calculator_id"
  end

  create_table "results", force: true do |t|
    t.float    "value"
    t.integer  "calculator_id"
    t.string   "result_type"
    t.string   "operation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
