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

ActiveRecord::Schema[7.1].define(version: 2024_03_14_211926) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "account_roles", ["admin", "manager", "accounting_clerk", "lead", "employee"]
  create_enum "transaction_types", ["withdraw", "payment", "deposit"]

  create_table "accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "disabled_at"
    t.string "full_name"
    t.string "position"
    t.boolean "active", default: true
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "role", default: "employee", null: false, enum_type: "account_roles"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "balance", precision: 15, scale: 6, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_balances_on_account_id"
  end

  create_table "billing_cycles", force: :cascade do |t|
    t.uuid "public_id"
    t.text "description"
    t.datetime "start_time", precision: nil, null: false
    t.datetime "finish_time", precision: nil
    t.datetime "closed_at", precision: nil
    t.boolean "opened", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.boolean "pay_status"
    t.decimal "amount", precision: 15, scale: 6
    t.datetime "pay_time", precision: nil
    t.bigint "billing_cycle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "transaction_id"
    t.index ["account_id"], name: "index_payments_on_account_id"
    t.index ["billing_cycle_id"], name: "index_payments_on_billing_cycle_id"
    t.index ["transaction_id"], name: "index_payments_on_transaction_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "account_id"
    t.uuid "public_id"
    t.decimal "fee", precision: 15, scale: 6, default: "0.0", null: false
    t.decimal "price", precision: 15, scale: 6, default: "0.0", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_tasks_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id"
    t.uuid "public_id"
    t.decimal "debit", precision: 15, scale: 6
    t.decimal "credit", precision: 15, scale: 6
    t.text "description"
    t.bigint "billing_cycle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "transaction_type", default: "deposit", null: false, enum_type: "transaction_types"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["billing_cycle_id"], name: "index_transactions_on_billing_cycle_id"
  end

  create_table "unprocessed_events", force: :cascade do |t|
    t.text "raw_event"
    t.integer "status", default: 0, null: false
    t.integer "retry_count"
    t.datetime "next_retry_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_unprocessed_events_on_status"
  end

  add_foreign_key "balances", "accounts"
  add_foreign_key "payments", "accounts"
  add_foreign_key "payments", "billing_cycles"
  add_foreign_key "tasks", "accounts"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "billing_cycles"
end
