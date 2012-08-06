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

ActiveRecord::Schema.define(:version => 20120731174049) do

  create_table "admin_users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "name"
    t.string   "surname"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "assetable_type"
    t.integer  "assetable_id"
    t.string   "type"
    t.string   "media_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "option_types", :force => true do |t|
    t.string   "name"
    t.string   "presentation"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "option_value_variants", :force => true do |t|
    t.integer  "option_value_id"
    t.integer  "variant_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "option_value_variants", ["option_value_id", "variant_id"], :name => "index_option_value_variants_on_option_value_id_and_variant_id", :unique => true

  create_table "option_values", :force => true do |t|
    t.string   "name"
    t.string   "display"
    t.integer  "option_type_id", :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "position"
  end

  create_table "product_option_types", :force => true do |t|
    t.integer  "option_type_id", :null => false
    t.integer  "product_id",     :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "product_option_types", ["option_type_id", "product_id"], :name => "index_product_option_types_on_option_type_id_and_product_id", :unique => true

  create_table "products", :force => true do |t|
    t.text     "description"
    t.string   "permalink"
    t.datetime "avaible_on"
    t.boolean  "is_active",   :default => false, :null => false
    t.datetime "expires_on"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "name"
  end

  create_table "related_products", :force => true do |t|
    t.integer  "related_product_id"
    t.integer  "product_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "user_wishlists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "wishlist_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_wishlists", ["user_id", "wishlist_id"], :name => "index_user_wishlists_on_user_id_and_wishlist_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "current_token"
    t.date     "birth_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "variants", :force => true do |t|
    t.string   "sku",                       :null => false
    t.integer  "product_id",                :null => false
    t.integer  "avaible",    :default => 0, :null => false
    t.boolean  "is_master",                 :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.float    "price"
  end

  add_index "variants", ["product_id"], :name => "index_variants_on_product_id"

  create_table "wishlist_variant_votes", :force => true do |t|
    t.integer  "wishlist_id"
    t.integer  "variant_id"
    t.boolean  "vote"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "wishlist_variant_votes", ["wishlist_id", "variant_id"], :name => "index_wishlist_variant_votes_on_wishlist_id_and_variant_id", :unique => true

  create_table "wishlist_variants", :force => true do |t|
    t.integer  "wishlist_id"
    t.integer  "variant_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "wishlist_variants", ["wishlist_id", "variant_id"], :name => "index_wishlist_variants_on_wishlist_id_and_variant_id", :unique => true

  create_table "wishlists", :force => true do |t|
    t.integer  "user_admin_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "active",                    :default => true, :null => false
    t.string   "gift_receiver_facebook_id"
  end

  add_index "wishlists", ["user_admin_id"], :name => "index_wishlists_on_user_admin_id"

end
