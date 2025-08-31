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

ActiveRecord::Schema[8.0].define(version: 2025_08_26_200918) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "flash_cards_sets", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.string "name", null: false
    t.jsonb "content", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_flash_cards_sets_on_content", using: :gin
    t.index ["name"], name: "index_flash_cards_sets_on_name"
    t.index ["workspace_id"], name: "index_flash_cards_sets_on_workspace_id"
  end

  create_table "icons", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mindmaps", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.string "name"
    t.jsonb "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workspace_id"], name: "index_mindmaps_on_workspace_id"
  end

  create_table "quiz_session_answers", force: :cascade do |t|
    t.bigint "quiz_session_id", null: false
    t.string "question_id", null: false
    t.text "question_text", null: false
    t.string "question_type", null: false
    t.json "user_answers", null: false
    t.json "correct_answers", null: false
    t.boolean "is_correct", null: false
    t.integer "time_spent_seconds"
    t.integer "attempts_count", default: 1
    t.text "explanation_shown"
    t.json "analytics_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_correct"], name: "index_quiz_session_answers_on_is_correct"
    t.index ["question_type"], name: "index_quiz_session_answers_on_question_type"
    t.index ["quiz_session_id", "question_id"], name: "index_quiz_session_answers_on_quiz_session_id_and_question_id"
    t.index ["quiz_session_id"], name: "index_quiz_session_answers_on_quiz_session_id"
  end

  create_table "quiz_sessions", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.bigint "quiz_id", null: false
    t.bigint "user_id", null: false
    t.datetime "started_at", null: false
    t.datetime "completed_at"
    t.integer "duration_seconds", default: 0
    t.integer "score", default: 0
    t.integer "total_questions", null: false
    t.decimal "accuracy_percentage", precision: 5, scale: 2
    t.string "quiz_mode", null: false
    t.string "session_type", default: "standard"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed_at"], name: "index_quiz_sessions_on_completed_at"
    t.index ["quiz_id"], name: "index_quiz_sessions_on_quiz_id"
    t.index ["user_id", "quiz_mode"], name: "index_quiz_sessions_on_user_id_and_quiz_mode"
    t.index ["user_id"], name: "index_quiz_sessions_on_user_id"
    t.index ["workspace_id", "created_at"], name: "index_quiz_sessions_on_workspace_id_and_created_at"
    t.index ["workspace_id"], name: "index_quiz_sessions_on_workspace_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.string "title"
    t.text "description"
    t.jsonb "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workspace_id"], name: "index_quizzes_on_workspace_id"
  end

  create_table "raw_contents", force: :cascade do |t|
    t.bigint "workspace_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.index ["workspace_id"], name: "index_raw_contents_on_workspace_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "icon_id"
    t.index ["icon_id"], name: "index_workspaces_on_icon_id"
    t.index ["user_id"], name: "index_workspaces_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "flash_cards_sets", "workspaces"
  add_foreign_key "mindmaps", "workspaces"
  add_foreign_key "quiz_session_answers", "quiz_sessions"
  add_foreign_key "quiz_sessions", "quizzes"
  add_foreign_key "quiz_sessions", "users"
  add_foreign_key "quiz_sessions", "workspaces"
  add_foreign_key "quizzes", "workspaces"
  add_foreign_key "raw_contents", "workspaces"
  add_foreign_key "workspaces", "icons"
  add_foreign_key "workspaces", "users"
end
