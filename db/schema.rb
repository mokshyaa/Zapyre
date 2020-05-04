# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_191_118_083_116) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'carts', force: :cascade do |t|
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_carts_on_user_id'
  end

  create_table 'carts_products', id: false, force: :cascade do |t|
    t.bigint 'product_id', null: false
    t.bigint 'cart_id', null: false
  end

  create_table 'orders', force: :cascade do |t|
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.float 'total'
    t.index ['user_id'], name: 'index_orders_on_user_id'
  end

  create_table 'orders_products', id: false, force: :cascade do |t|
    t.bigint 'product_id', null: false
    t.bigint 'order_id', null: false
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name'
    t.float 'price'
    t.string 'brand'
    t.text 'description'
    t.string 'offer'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'image_file_name'
    t.string 'image_content_type'
    t.bigint 'image_file_size'
    t.datetime 'image_updated_at'
    t.integer 'available_quantity'
  end

  create_table 'products_wishlists', id: false, force: :cascade do |t|
    t.bigint 'product_id', null: false
    t.bigint 'wishlist_id', null: false
  end

  create_table 'quantities', force: :cascade do |t|
    t.integer 'quantity'
    t.bigint 'product_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'qnt_type'
    t.bigint 'qnt_id'
    t.index ['product_id'], name: 'index_quantities_on_product_id'
    t.index %w[qnt_type qnt_id], name: 'index_quantities_on_qnt_type_and_qnt_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'name'
    t.integer 'role'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'avatar_file_name'
    t.string 'avatar_content_type'
    t.bigint 'avatar_file_size'
    t.datetime 'avatar_updated_at'
    t.string 'provider'
    t.string 'uid'
    t.string 'stripe_id'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  create_table 'wishlists', force: :cascade do |t|
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_wishlists_on_user_id'
  end

  add_foreign_key 'carts', 'users'
  add_foreign_key 'orders', 'users'
  add_foreign_key 'quantities', 'products'
  add_foreign_key 'wishlists', 'users'
end
