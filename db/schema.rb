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

ActiveRecord::Schema.define(version: 20150908083258) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: true do |t|
    t.string   "owner"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "total_score"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["owner"], name: "index_contacts_on_owner", using: :btree

  create_table "score", force: true do |t|
    t.string   "method"
    t.integer  "value"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "score", ["contact_id"], name: "index_score_on_contact_id", using: :btree

  create_table "scores", force: true do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["contact_id"], name: "index_scores_on_contact_id", using: :btree

  create_table "vectors", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.json     "additions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
  end

  add_index "vectors", ["contact_id"], name: "index_vectors_on_contact_id", using: :btree
  add_index "vectors", ["value"], name: "index_vectors_on_value", using: :btree

end
