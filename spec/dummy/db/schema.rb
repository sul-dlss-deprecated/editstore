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

ActiveRecord::Schema.define(:version => 20131017165120) do

  create_table "editstore_changes", :force => true do |t|
    t.integer  "project_id",                     :null => false
    t.string   "field",                          :null => false
    t.string   "druid",                          :null => false
    t.text     "old_value"
    t.text     "new_value"
    t.string   "operation",                      :null => false
    t.integer  "state_id",                       :null => false
    t.text     "client_note"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "error"
    t.boolean  "pending",     :default => false
  end

  add_index "editstore_changes", ["druid"], :name => "index_editstore_changes_on_druid"
  add_index "editstore_changes", ["project_id"], :name => "index_editstore_changes_on_project_id"
  add_index "editstore_changes", ["state_id"], :name => "index_editstore_changes_on_state_id"

  create_table "editstore_fields", :force => true do |t|
    t.integer  "project_id", :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "editstore_fields", ["project_id"], :name => "index_editstore_fields_on_project_id"

  create_table "editstore_object_locks", :force => true do |t|
    t.string   "druid",        :null => false
    t.datetime "locked"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "lock_version"
  end

  add_index "editstore_object_locks", ["druid"], :name => "index_editstore_object_locks_on_druid"
  add_index "editstore_object_locks", ["locked"], :name => "index_editstore_object_locks_on_locked"

  create_table "editstore_projects", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "template",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "editstore_run_logs", :force => true do |t|
    t.integer  "total_druids"
    t.integer  "total_changes"
    t.integer  "num_errors"
    t.integer  "num_pending"
    t.string   "note"
    t.datetime "started"
    t.datetime "ended"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "editstore_states", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
