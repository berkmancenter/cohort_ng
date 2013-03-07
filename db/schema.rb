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

ActiveRecord::Schema.define(:version => 20130306213025) do

  create_table "addresses", :force => true do |t|
    t.string   "address_type", :limit => 20,  :default => "unknown"
    t.string   "address_1",    :limit => 150
    t.string   "address_2",    :limit => 150
    t.string   "city",         :limit => 100
    t.string   "state",        :limit => 100
    t.string   "postal_code",  :limit => 30
    t.string   "country",      :limit => 2,                          :null => false
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["address_1"], :name => "index_addresses_on_address_1"
  add_index "addresses", ["address_type"], :name => "index_addresses_on_address_type"
  add_index "addresses", ["city"], :name => "index_addresses_on_city"
  add_index "addresses", ["contact_id"], :name => "index_addresses_on_contact_id"
  add_index "addresses", ["country"], :name => "index_addresses_on_country"
  add_index "addresses", ["postal_code"], :name => "index_addresses_on_postal_code"
  add_index "addresses", ["state"], :name => "index_addresses_on_state"

  create_table "contact_carts", :force => true do |t|
    t.string   "name",        :limit => 250,                    :null => false
    t.string   "description", :limit => 5120
    t.boolean  "global",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_carts", ["global"], :name => "index_contact_carts_on_global"
  add_index "contact_carts", ["name"], :name => "index_contact_carts_on_name"

  create_table "contact_sources", :force => true do |t|
    t.integer  "contact_cart_id"
    t.string   "contact_input_type"
    t.integer  "contact_input_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_sources", ["contact_cart_id", "contact_input_type", "contact_input_id"], :name => "george", :unique => true
  add_index "contact_sources", ["contact_cart_id"], :name => "index_contact_sources_on_contact_cart_id"
  add_index "contact_sources", ["contact_input_id"], :name => "index_contact_sources_on_contact_input_id"
  add_index "contact_sources", ["contact_input_type"], :name => "index_contact_sources_on_contact_input_type"

  create_table "contacts", :force => true do |t|
    t.string   "first_name", :limit => 100,                    :null => false
    t.string   "last_name",  :limit => 100,                    :null => false
    t.date     "birthday"
    t.boolean  "active",                    :default => true
    t.boolean  "deleted",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "contacts", ["active"], :name => "index_contacts_on_active"
  add_index "contacts", ["birthday"], :name => "index_contacts_on_birthday"
  add_index "contacts", ["deleted"], :name => "index_contacts_on_deleted"
  add_index "contacts", ["first_name"], :name => "index_contacts_on_first_name"
  add_index "contacts", ["last_name"], :name => "index_contacts_on_last_name"

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.string   "document_type",   :limit => 50
    t.string   "description",     :limit => 4096
    t.string   "file_attachment",                                      :null => false
    t.boolean  "needs_indexing",                     :default => true
    t.string   "content",         :limit => 5242880
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["contact_id"], :name => "index_documents_on_contact_id"
  add_index "documents", ["document_type"], :name => "index_documents_on_document_type"
  add_index "documents", ["file_attachment"], :name => "index_documents_on_file_attachment"

  create_table "emails", :force => true do |t|
    t.string   "email",      :limit => 150,                        :null => false
    t.string   "email_type", :limit => 50,  :default => "unknown"
    t.boolean  "is_primary"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["contact_id"], :name => "index_emails_on_contact_id"
  add_index "emails", ["email"], :name => "index_emails_on_email", :unique => true
  add_index "emails", ["email_type"], :name => "index_emails_on_email_type"
  add_index "emails", ["is_primary"], :name => "index_emails_on_is_primary"

  create_table "log_items", :force => true do |t|
    t.string   "log_item_type", :limit => 100,  :default => "update"
    t.string   "log_entry",     :limit => 4096,                       :null => false
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "log_items", ["contact_id"], :name => "index_log_items_on_contact_id"
  add_index "log_items", ["log_item_type"], :name => "index_log_items_on_log_item_type"

  create_table "notes", :force => true do |t|
    t.string   "note",       :limit => 12288,                        :null => false
    t.string   "note_type",  :limit => 50,    :default => "general"
    t.datetime "due_date"
    t.integer  "priority",                    :default => 50
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["contact_id"], :name => "index_notes_on_contact_id"
  add_index "notes", ["due_date"], :name => "index_notes_on_due_date"
  add_index "notes", ["note_type"], :name => "index_notes_on_note_type"
  add_index "notes", ["priority"], :name => "index_notes_on_priority"

  create_table "phone_numbers", :force => true do |t|
    t.integer  "contact_id"
    t.string   "phone",      :limit => 25,                        :null => false
    t.string   "phone_type", :limit => 50, :default => "unknown"
    t.boolean  "is_primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_numbers", ["contact_id"], :name => "index_phone_numbers_on_contact_id"
  add_index "phone_numbers", ["is_primary"], :name => "index_phone_numbers_on_is_primary"
  add_index "phone_numbers", ["phone_type"], :name => "index_phone_numbers_on_phone_type"

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["authorizable_id"], :name => "index_roles_on_authorizable_id"
  add_index "roles", ["authorizable_type"], :name => "index_roles_on_authorizable_type"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "saved_search_runs", :force => true do |t|
    t.integer  "saved_search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "saved_search_runs", ["saved_search_id"], :name => "index_saved_search_runs_on_saved_search_id"

  create_table "saved_searches", :force => true do |t|
    t.string   "name",                                          :null => false
    t.string   "description", :limit => 1024
    t.string   "search_url",  :limit => 2048
    t.boolean  "global",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "saved_searches", ["global"], :name => "index_saved_searches_on_global"
  add_index "saved_searches", ["name"], :name => "index_saved_searches_on_name"
  add_index "saved_searches", ["search_url"], :name => "index_saved_searches_on_search_url"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.string  "ancestry"
    t.integer "position"
  end

  add_index "tags", ["ancestry"], :name => "index_tags_on_ancestry"
  add_index "tags", ["name"], :name => "index_tags_on_name"
  add_index "tags", ["position"], :name => "index_tags_on_position"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",   :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "first_name",             :limit => 100
    t.string   "last_name",              :limit => 100
    t.string   "url",                    :limit => 250
    t.boolean  "deleteable",                            :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
