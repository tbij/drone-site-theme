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

ActiveRecord::Schema.define(version: 20170221141653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "spreadsheet_key"
    t.string   "spreadsheet_tab"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "country_id"
    t.string   "description"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["country_id"], name: "index_locations_on_country_id", using: :btree
  end

  create_table "strikes", force: :cascade do |t|
    t.integer  "country_id"
    t.integer  "location_id"
    t.string   "strike_id"
    t.date     "date"
    t.integer  "minimum_people_killed"
    t.integer  "maximum_people_killed"
    t.integer  "minimum_civilians_killed"
    t.integer  "maximum_civilians_killed"
    t.integer  "minimum_children_killed"
    t.integer  "maximum_children_killed"
    t.integer  "minimum_people_injured"
    t.integer  "maximum_people_injured"
    t.integer  "index"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "minimum_strikes",          default: 1
    t.integer  "maximum_strikes",          default: 1
    t.index ["country_id"], name: "index_strikes_on_country_id", using: :btree
    t.index ["location_id"], name: "index_strikes_on_location_id", using: :btree
  end

end
