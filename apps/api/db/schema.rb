# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_18_210457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "email_notifications", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.boolean "like", default: true
    t.boolean "comment", default: true
    t.boolean "newsletter", default: true
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_email_notifications_on_user_id"
    t.index ["uuid"], name: "index_email_notifications_on_uuid", unique: true
  end

  create_table "streaks", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_streaks_on_user_id"
    t.index ["uuid"], name: "index_streaks_on_uuid", unique: true
  end

  create_table "task_comments", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["task_id"], name: "index_task_comments_on_task_id"
    t.index ["user_id"], name: "index_task_comments_on_user_id"
    t.index ["uuid"], name: "index_task_comments_on_uuid", unique: true
  end

  create_table "task_groups", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_task_groups_on_user_id"
    t.index ["uuid"], name: "index_task_groups_on_uuid", unique: true
  end

  create_table "task_likes", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["state"], name: "index_task_likes_on_state"
    t.index ["task_id"], name: "index_task_likes_on_task_id"
    t.index ["user_id"], name: "index_task_likes_on_user_id"
    t.index ["uuid"], name: "index_task_likes_on_uuid", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.text "content"
    t.integer "state", default: 0, null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "task_group_id", null: false
    t.bigint "streak_id"
    t.index ["streak_id"], name: "index_tasks_on_streak_id"
    t.index ["task_group_id"], name: "index_tasks_on_task_group_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
    t.index ["uuid"], name: "index_tasks_on_uuid", unique: true
  end

  create_table "tokens", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "token"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
    t.index ["uuid"], name: "index_tokens_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "username", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "timezone", default: "Europe/Paris"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uuid"], name: "index_webhooks_on_uuid", unique: true
  end

  add_foreign_key "email_notifications", "users"
  add_foreign_key "streaks", "users"
  add_foreign_key "task_comments", "tasks"
  add_foreign_key "task_comments", "users"
  add_foreign_key "task_groups", "users"
  add_foreign_key "task_likes", "tasks"
  add_foreign_key "task_likes", "users"
end
