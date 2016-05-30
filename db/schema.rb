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

ActiveRecord::Schema.define(version: 20160530135610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string   "owner_mkey",   limit: 255
    t.string   "first_name",   limit: 255
    t.string   "last_name",    limit: 255
    t.integer  "total_score"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zazo_id"
    t.string   "zazo_mkey",    limit: 255
    t.json     "additions"
    t.string   "display_name", limit: 255
  end

  add_index "contacts", ["owner_mkey"], name: "index_contacts_on_owner_mkey", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "kind",       limit: 255
    t.string   "state",      limit: 255
    t.string   "status",     limit: 255
    t.string   "category",   limit: 255
    t.json     "additions"
    t.string   "nkey",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
  end

  add_index "notifications", ["contact_id"], name: "index_notifications_on_contact_id", using: :btree

  create_table "owners", force: :cascade do |t|
    t.string   "mkey",         limit: 255
    t.boolean  "unsubscribed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owners", ["mkey"], name: "index_owners_on_mkey", using: :btree

  create_table "scores", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "value"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["contact_id"], name: "index_scores_on_contact_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "vectors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.json     "additions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
  end

  add_index "vectors", ["contact_id"], name: "index_vectors_on_contact_id", using: :btree
  add_index "vectors", ["value"], name: "index_vectors_on_value", using: :btree

end
