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

ActiveRecord::Schema[7.0].define(version: 2023_11_09_210953) do
  create_table "factions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.integer "unit", null: false
    t.integer "movement"
    t.integer "toughness"
    t.integer "save_value"
    t.integer "wounds"
    t.integer "leadership"
    t.integer "objective_control"
    t.integer "invulnerable_save"
    t.string "base"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", force: :cascade do |t|
    t.integer "small"
    t.integer "large"
    t.integer "faction_id", null: false
    t.boolean "captain"
    t.integer "damage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
