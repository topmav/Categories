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

ActiveRecord::Schema[8.0].define(version: 2025_01_17_202402) do
  create_schema "auth"
  create_schema "cable"
  create_schema "cache"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "pgsodium"
  create_schema "pgsodium_masks"
  create_schema "queue"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.pgjwt"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgsodium.pgsodium"
  enable_extension "vault.supabase_vault"

  create_table "categories", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.text "qualified_lead_desc"
    t.text "unqualified_lead_desc"
    t.decimal "suggested_lead_pricing", precision: 10, scale: 2
    t.text "pricing_factors"
    t.integer "monthly_search_volume"
    t.decimal "customer_lifetime_value", precision: 10, scale: 2
    t.decimal "cpc_low", precision: 10, scale: 2
    t.decimal "cpc_high", precision: 10, scale: 2
    t.text "viability_assessment"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
  end

  create_table "form_answers", force: :cascade do |t|
    t.bigint "form_question_id", null: false
    t.text "answer", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["form_question_id"], name: "index_form_answers_on_form_question_id"
  end

  create_table "form_questions", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.text "question", null: false
    t.text "question_type"
    t.text "reasoning"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["category_id"], name: "index_form_questions_on_category_id"
  end

  create_table "forms", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.json "form_data"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["category_id"], name: "index_forms_on_category_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.text "keyword", null: false
    t.integer "monthly_search_volume"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["category_id"], name: "index_keywords_on_category_id"
    t.index ["keyword"], name: "index_keywords_on_keyword"
  end

  create_table "sellers", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.text "name", null: false
    t.text "website"
    t.text "size"
    t.text "note"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["category_id"], name: "index_sellers_on_category_id"
  end

  add_foreign_key "form_answers", "form_questions"
  add_foreign_key "form_questions", "categories"
  add_foreign_key "forms", "categories"
  add_foreign_key "keywords", "categories"
  add_foreign_key "sellers", "categories"
end
