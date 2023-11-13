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

ActiveRecord::Schema[7.0].define(version: 2023_11_13_205834) do
  create_table "equipment", force: :cascade do |t|
    t.integer "model_id", null: false
    t.integer "weapon", null: false
    t.integer "limits"
    t.integer "slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_id"], name: "index_equipment_on_model_id"
    t.index ["weapon"], name: "index_equipment_on_weapon"
  end

  create_table "factions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.integer "movement"
    t.integer "toughness"
    t.integer "save_value"
    t.integer "invulnerable_save"
    t.integer "wounds"
    t.integer "leadership"
    t.integer "objective_control"
    t.integer "unit_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_models_on_unit_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.integer "weapon_id", null: false
    t.string "attacks"
    t.integer "skill"
    t.integer "strength"
    t.integer "aarmor_piercing"
    t.string "damage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weapon_id"], name: "index_profiles_on_weapon_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.integer "faction_id", null: false
    t.integer "cost"
    t.integer "min_size"
    t.integer "max_size"
    t.string "role"
    t.boolean "damage"
    t.integer "dmg_amount"
    t.boolean "captain"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faction_id"], name: "index_units_on_faction_id"
  end

  create_table "weapons", force: :cascade do |t|
    t.string "name"
    t.integer "range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
