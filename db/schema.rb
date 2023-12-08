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

ActiveRecord::Schema[7.0].define(version: 2023_12_06_152122) do
  create_table "abilities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "classification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bodyguards", force: :cascade do |t|
    t.integer "leader_id", null: false
    t.integer "unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id"], name: "index_bodyguards_on_leader_id"
    t.index ["unit_id"], name: "index_bodyguards_on_unit_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.integer "model_id", null: false
    t.integer "weapon_id", null: false
    t.integer "limits"
    t.integer "slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "factions", force: :cascade do |t|
    t.string "name"
    t.string "banner"
    t.string "icon"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.string "name"
    t.integer "unit_id", null: false
    t.integer "movement"
    t.integer "toughness"
    t.integer "save_value"
    t.integer "invulnerable_save"
    t.integer "wounds"
    t.integer "leadership"
    t.integer "objective_control"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_models_on_unit_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "weapon_id", null: false
    t.string "attacks"
    t.integer "skill"
    t.integer "strength"
    t.integer "armor_piercing"
    t.string "damage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["weapon_id"], name: "index_profiles_on_weapon_id"
  end

  create_table "unit_abilities", force: :cascade do |t|
    t.integer "unit_id", null: false
    t.integer "ability_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unit_keywords", force: :cascade do |t|
    t.integer "unit_id", null: false
    t.integer "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_unit_keywords_on_keyword_id"
    t.index ["unit_id"], name: "index_unit_keywords_on_unit_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.integer "cost"
    t.integer "faction_id", null: false
    t.integer "max_size"
    t.string "base_size"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "models_per_unit"
    t.index ["faction_id"], name: "index_units_on_faction_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.string "name"
    t.integer "range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
