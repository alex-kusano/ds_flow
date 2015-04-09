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

ActiveRecord::Schema.define(version: 20150409033151) do

  create_table "categories", force: true do |t|
    t.integer  "company_id"
    t.string   "tab_name"
    t.string   "tab_value"
    t.integer  "datatype"
    t.integer  "operation"
    t.string   "code"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["company_id"], name: "index_categories_on_company_id"
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connect_configs", force: true do |t|
    t.integer  "send_interface_id"
    t.integer  "sign_interface_id"
    t.integer  "account_id"
    t.integer  "true"
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

  create_table "ds_accounts", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "external_id"
    t.string   "base_url"
    t.string   "user_id"
  end

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

  create_table "flow_candidates", force: true do |t|
    t.integer  "flow_instance_id"
    t.integer  "employment_id"
    t.datetime "sign_date"
    t.string   "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flow_candidates", ["employment_id"], name: "index_flow_candidates_on_employment_id"
  add_index "flow_candidates", ["flow_instance_id"], name: "index_flow_candidates_on_flow_instance_id"
  add_index "flow_candidates", ["flow_instance_id"], name: "index_flow_candidates_on_flow_instance_id_and_routing_order"

  create_table "flow_flow_instances", force: true do |t|
    t.string   "code"
    t.string   "envelope_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "routing_order"
    t.datetime "complete_date"
    t.integer  "company_id"
  end

  add_index "flow_flow_instances", ["code", "envelope_id"], name: "index_flow_flow_instances_on_code_and_envelope_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rule_sets", force: true do |t|
    t.string   "code"
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
