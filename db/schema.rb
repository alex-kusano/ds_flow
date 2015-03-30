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

ActiveRecord::Schema.define(version: 20150330013557) do

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "criteria", force: true do |t|
    t.integer  "role_id"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rule_id"
  end

  add_index "criteria", ["role_id"], name: "index_criteria_on_role_id"
  add_index "criteria", ["rule_id"], name: "index_criteria_on_rule_id"

  create_table "employments", force: true do |t|
    t.integer  "company_id"
    t.integer  "contact_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employments", ["company_id", "role_id"], name: "index_employments_on_company_id_and_role_id"
  add_index "employments", ["company_id"], name: "index_employments_on_company_id"
  add_index "employments", ["contact_id"], name: "index_employments_on_contact_id"

  create_table "flow_flow_instances", force: true do |t|
    t.string   "code"
    t.string   "envelope_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flow_flow_instances", ["code", "envelope_id"], name: "index_flow_flow_instances_on_code_and_envelope_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rule_sets", force: true do |t|
    t.string   "code"
    t.integer  "routing_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rule_set_id"
  end

  add_index "rules", ["rule_set_id"], name: "index_rules_on_rule_set_id"

end
