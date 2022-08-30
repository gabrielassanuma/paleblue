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

ActiveRecord::Schema[7.0].define(version: 2022_08_29_181151) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "creators", force: :cascade do |t|
    t.bigint "token_id", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reset_password_token"], name: "index_creators_on_reset_password_token", unique: true
    t.index ["token_id"], name: "index_creators_on_token_id"
  end

  create_table "raffles", force: :cascade do |t|
    t.text "name"
    t.text "about"
    t.string "tag1"
    t.string "tag2"
    t.string "tag3"
    t.bigint "creator_id", null: false
    t.bigint "token_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_raffles_on_creator_id"
    t.index ["token_id"], name: "index_raffles_on_token_id"
  end

  create_table "tk_balances", force: :cascade do |t|
    t.bigint "tk_amount"
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
    t.boolean "unlimited"
    t.bigint "max_mint"
    t.bigint "minted_so_far"
    t.float "price"
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
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "creators", "tokens"
  add_foreign_key "raffles", "creators"
  add_foreign_key "raffles", "tokens"
  add_foreign_key "tk_balances", "tokens"
  add_foreign_key "tk_balances", "users"
  add_foreign_key "tokens", "users"
  add_foreign_key "transactions", "tokens"
  add_foreign_key "transactions", "users", column: "from_user_id"
  add_foreign_key "transactions", "users", column: "to_user_id"
end
