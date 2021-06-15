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

ActiveRecord::Schema.define(version: 2021_06_15_204035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    t.index ["uuid"], name: "index_active_storage_attachments_on_uuid", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.bigint "task_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["uuid"], name: "index_comments_on_uuid", unique: true
  end

  create_table "email_notifications", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.boolean "like", default: true
    t.boolean "comment", default: true
    t.boolean "newsletter", default: true
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_email_notifications_on_user_id"
    t.index ["uuid"], name: "index_email_notifications_on_uuid", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.bigint "task_id"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["state"], name: "index_likes_on_state"
    t.index ["user_id"], name: "index_likes_on_user_id"
    t.index ["uuid"], name: "index_likes_on_uuid", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "slug", null: false
    t.string "name"
    t.text "description"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.string "main_color", default: "#2589C7", null: false
    t.string "github_secret"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
    t.index ["uuid"], name: "index_projects_on_uuid", unique: true
  end

  create_table "projects_tasks", id: false, force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "task_id"
    t.index ["project_id"], name: "index_projects_tasks_on_project_id"
    t.index ["task_id"], name: "index_projects_tasks_on_task_id"
  end

  create_table "streaks", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_streaks_on_user_id"
    t.index ["uuid"], name: "index_streaks_on_uuid", unique: true
  end

  create_table "task_groups", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_task_groups_on_user_id"
    t.index ["uuid"], name: "index_task_groups_on_uuid", unique: true
  end

  create_table "task_mentions", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "task_id"
    t.index ["task_id"], name: "index_task_mentions_on_task_id"
    t.index ["user_id"], name: "index_task_mentions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.text "content"
    t.integer "state", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "task_group_id", null: false
    t.bigint "streak_id"
    t.integer "source", default: 0, null: false
    t.index ["source"], name: "index_tasks_on_source"
    t.index ["streak_id"], name: "index_tasks_on_streak_id"
    t.index ["task_group_id"], name: "index_tasks_on_task_group_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
    t.index ["uuid"], name: "index_tasks_on_uuid", unique: true
  end

  create_table "tokens", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "token", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ip"
    t.integer "status", default: 0, null: false
    t.index ["token"], name: "index_tokens_on_token", unique: true
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
    t.integer "status", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["status"], name: "index_users_on_status"
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "webhook_requests", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.integer "state", default: 0, null: false
    t.string "event", null: false
    t.bigint "webhook_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "data"
    t.index ["state"], name: "index_webhook_requests_on_state"
    t.index ["uuid"], name: "index_webhook_requests_on_uuid", unique: true
    t.index ["webhook_id"], name: "index_webhook_requests_on_webhook_id"
  end

  create_table "webhooks", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "secret"
    t.bigint "user_id"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_webhooks_on_project_id"
    t.index ["user_id"], name: "index_webhooks_on_user_id"
    t.index ["uuid"], name: "index_webhooks_on_uuid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "tasks"
  add_foreign_key "comments", "users"
  add_foreign_key "email_notifications", "users"
  add_foreign_key "likes", "tasks"
  add_foreign_key "likes", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "projects_tasks", "projects"
  add_foreign_key "projects_tasks", "tasks"
  add_foreign_key "streaks", "users"
  add_foreign_key "task_groups", "users"
  add_foreign_key "task_mentions", "tasks"
  add_foreign_key "task_mentions", "users"
  add_foreign_key "tasks", "streaks"
  add_foreign_key "tasks", "task_groups"
  add_foreign_key "tasks", "users"
  add_foreign_key "tokens", "users"
  add_foreign_key "webhooks", "projects"
  add_foreign_key "webhooks", "users"
end
