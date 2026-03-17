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

ActiveRecord::Schema[8.1].define(version: 2026_03_17_085732) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "abuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "reason", null: false
    t.bigint "reportable_id", null: false
    t.string "reportable_type", null: false
    t.bigint "reporter_id", null: false
    t.datetime "updated_at", null: false
    t.index ["reportable_type", "reportable_id"], name: "index_abuses_on_reportable"
    t.index ["reporter_id"], name: "index_abuses_on_reporter_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.boolean "abusive", default: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.integer "net_votes", default: 0
    t.bigint "question_id", null: false
    t.integer "status", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.boolean "abusive", default: false
    t.bigint "commentable_id", null: false
    t.string "commentable_type", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "credit_purchases", force: :cascade do |t|
    t.bigint "amount"
    t.datetime "created_at", null: false
    t.integer "status"
    t.string "stripe_transaction_id", null: false
    t.integer "unit"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["stripe_transaction_id"], name: "index_credit_purchases_on_stripe_transaction_id", unique: true
    t.index ["user_id"], name: "index_credit_purchases_on_user_id"
  end

  create_table "credit_transactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "reason"
    t.bigint "source_id"
    t.string "source_type"
    t.integer "type", null: false
    t.bigint "units", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["source_type", "source_id"], name: "index_credit_transactions_on_source"
    t.index ["user_id"], name: "index_credit_transactions_on_user_id"
    t.check_constraint "units > 0"
  end

  create_table "followers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "followee_id", null: false
    t.bigint "follower_id", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_followers_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_followers_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_followers_on_follower_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "message", null: false
    t.bigint "notifiable_id", null: false
    t.string "notifiable_type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.boolean "abusive", default: false
    t.text "content", default: ""
    t.datetime "created_at", null: false
    t.datetime "edited_at"
    t.datetime "posted_at"
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "topic_assignements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "topic_id", null: false
    t.bigint "topicable_id", null: false
    t.string "topicable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id", "topicable_type", "topicable_id"], name: "idx_on_topic_id_topicable_type_topicable_id_624a3b06bd", unique: true
    t.index ["topic_id"], name: "index_topic_assignements_on_topic_id"
    t.index ["topicable_type", "topicable_id"], name: "index_topic_assignements_on_topicable"
  end

  create_table "topics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "auth_token"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.integer "credits", default: 0
    t.boolean "disabled", default: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 1
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "verified", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "votable_id", null: false
    t.string "votable_type", null: false
    t.index ["user_id", "votable_type", "votable_id"], name: "index_votes_on_user_id_and_votable_type_and_votable_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
  end

  add_foreign_key "abuses", "users", column: "reporter_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "credit_purchases", "users"
  add_foreign_key "credit_transactions", "users"
  add_foreign_key "followers", "users", column: "followee_id"
  add_foreign_key "followers", "users", column: "follower_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "questions", "users"
  add_foreign_key "topic_assignements", "topics"
  add_foreign_key "votes", "users"
end
