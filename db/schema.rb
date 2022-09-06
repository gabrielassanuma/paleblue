# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_01_081614) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "creators", force: :cascade do |t|
    t.bigint "pale_blue_id", null: false
    t.bigint "file_key_id", null: false
    t.string "title"
    t.text "q1"
    t.text "q2"
    t.text "q3"
    t.boolean "non_profit"
    t.text "about"
    t.string "location"
    t.string "facebook"
    t.string "twitter"
    t.string "instagram"
    t.string "linkedin"
    t.string "website"
    t.string "discord"
    t.string "tag1"
    t.string "tag2"
    t.string "tag3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_key_id"], name: "index_creators_on_file_key_id"
    t.index ["pale_blue_id"], name: "index_creators_on_pale_blue_id"
  end

  create_table "nfts", force: :cascade do |t|
    t.string "name"
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_nfts_on_creator_id"
  end

  create_table "raffles", force: :cascade do |t|
    t.text "name"
    t.text "about"
    t.string "tag1"
    t.string "tag2"
    t.string "tag3"
    t.string "metadata"
    t.bigint "creator_id", null: false
    t.bigint "token_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_raffles_on_creator_id"
    t.index ["token_id"], name: "index_raffles_on_token_id"
  end

  create_table "tk_balances", force: :cascade do |t|
    t.bigint "tk_amount", default: 0
    t.bigint "user_id", null: false
    t.bigint "token_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token_id"], name: "index_tk_balances_on_token_id"
    t.index ["user_id"], name: "index_tk_balances_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "tk_address"
    t.string "nickname"
    t.boolean "unlimited", default: false
    t.bigint "max_mint", default: 1
    t.bigint "minted_so_far", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "tk_amount"
    t.bigint "from_user_id"
    t.bigint "to_user_id"
    t.bigint "token_id", null: false
    t.index ["from_user_id"], name: "index_transactions_on_from_user_id"
    t.index ["to_user_id"], name: "index_transactions_on_to_user_id"
    t.index ["token_id"], name: "index_transactions_on_token_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "wlt_address"
    t.string "encrypted_password", default: "", null: false
    t.string "nickname"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["wlt_address"], name: "index_users_on_wlt_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "creators", "tokens", column: "file_key_id"
  add_foreign_key "creators", "tokens", column: "pale_blue_id"
  add_foreign_key "nfts", "creators"
  add_foreign_key "raffles", "creators"
  add_foreign_key "raffles", "tokens"
  add_foreign_key "tk_balances", "tokens"
  add_foreign_key "tk_balances", "users"
  add_foreign_key "tokens", "users"
  add_foreign_key "transactions", "tokens"
  add_foreign_key "transactions", "users", column: "from_user_id"
  add_foreign_key "transactions", "users", column: "to_user_id"
end
