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

ActiveRecord::Schema[7.1].define(version: 2023_05_12_103455) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "glossaries", force: :cascade do |t|
    t.string "source_language_code"
    t.string "target_language_code"
    t.datetime "terms_changed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_language_code", "target_language_code"], name: "idx_on_source_language_code_target_language_code_18eb0d76e6", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string "key", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", force: :cascade do |t|
    t.string "source_term", null: false
    t.string "target_term", null: false
    t.bigint "glossary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["glossary_id"], name: "index_terms_on_glossary_id"
  end

  create_table "translations", force: :cascade do |t|
    t.string "source_language_code"
    t.string "target_language_code"
    t.text "source_text"
    t.datetime "terms_marked_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "terms", "glossaries"
end
