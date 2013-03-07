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

ActiveRecord::Schema.define(:version => 20130307202055) do

  create_table "authors", :force => true do |t|
    t.text     "given_name"
    t.text     "surname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.text     "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "genre"
    t.text     "isbn13"
    t.text     "isbn10"
    t.text     "publisher"
    t.integer  "year"
    t.integer  "author_id"
  end

  create_table "mailers", :force => true do |t|
    t.string   "subject"
    t.text     "body",       :limit => 255
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.datetime "sent_date"
  end

  create_table "physical_items", :force => true do |t|
    t.integer  "barcode_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "item_id"
  end

  create_table "rentals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "barcode_id"
    t.integer  "renewals"
    t.datetime "return_date"
    t.datetime "rent_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
