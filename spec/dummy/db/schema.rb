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

ActiveRecord::Schema.define(:version => 20130712183410) do

  create_table "editstore_changes", :force => true do |t|
    t.integer  "project_id",  :null => false
    t.string   "field",       :null => false
    t.string   "druid",       :null => false
    t.text     "old_value"
    t.text     "new_value"
    t.text     "operation",   :null => false
    t.integer  "state_id",    :null => false
    t.text     "client_note"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "editstore_fields", :force => true do |t|
    t.integer  "project_id", :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "editstore_projects", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "template",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "editstore_states", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
