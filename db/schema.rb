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

ActiveRecord::Schema[7.0].define(version: 2023_11_16_161933) do
  create_table "abilities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "classification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "models", force: :cascade do |t|
    t.string "name"
    t.integer "unit_it", null: false
    t.integer "movement"
    t.integer "toughness"
    t.integer "save_value"
    t.integer "invulnerable_save"
    t.integer "wounds"
    t.integer "leadership"
    t.integer "objective_control"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "unit_abilities", force: :cascade do |t|
    t.integer "unit_id"
    t.integer "abilities_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.integer "cost"
    t.integer "faction_id", null: false
    t.integer "max_size"
    t.integer "base_size"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weapons", force: :cascade do |t|
    t.string "name"
    t.integer "range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
