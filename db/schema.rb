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

ActiveRecord::Schema.define(version: 20151106132950) do

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
    t.integer  "zazo_id"
    t.string   "zazo_mkey"
    t.json     "additions"
    t.string   "display_name"
  end

  add_index "contacts", ["owner"], name: "index_contacts_on_owner", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "state"
    t.string   "status"
    t.string   "category"
    t.json     "additions"
    t.string   "nkey"
    t.string   "compiled_content"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
  end

  add_index "notifications", ["contact_id"], name: "index_notifications_on_contact_id", using: :btree
  add_index "notifications", ["template_id"], name: "index_notifications_on_template_id", using: :btree

  create_table "scores", force: true do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["contact_id"], name: "index_scores_on_contact_id", using: :btree

  create_table "templates", force: true do |t|
    t.string   "category"
    t.string   "kind"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
