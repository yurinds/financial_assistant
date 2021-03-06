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

ActiveRecord::Schema.define(version: 2020_06_12_164136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.bigint "budget_id"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_attachments_on_budget_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.bigint "user_id"
    t.date "date_from"
    t.date "date_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "save_percent", default: 0
    t.bigint "attachment_id"
    t.index ["attachment_id"], name: "index_budgets_on_attachment_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "operation_type"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "operations", force: :cascade do |t|
    t.date "date"
    t.integer "operation_type"
    t.string "description"
    t.integer "amount"
    t.bigint "category_id"
    t.bigint "budget_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payment_method_id"
    t.string "mcc", limit: 4
    t.index ["budget_id"], name: "index_operations_on_budget_id"
    t.index ["category_id"], name: "index_operations_on_category_id"
    t.index ["payment_method_id"], name: "index_operations_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.text "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_cash", default: false
    t.index ["user_id"], name: "index_payment_methods_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attachments", "budgets"
  add_foreign_key "budgets", "attachments"
  add_foreign_key "budgets", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "operations", "budgets"
  add_foreign_key "operations", "categories"
  add_foreign_key "operations", "payment_methods"
  add_foreign_key "payment_methods", "users"
end
