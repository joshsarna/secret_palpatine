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

ActiveRecord::Schema.define(version: 2021_05_07_051147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.boolean "has_started"
    t.string "queen_id"
    t.string "chancellor_id"
    t.integer "remaining_republic_policy_count"
    t.integer "remaining_separatist_policy_count"
    t.integer "enacted_republic_policy_count"
    t.integer "enacted_separatist_policy_count"
    t.string "appointed_chancellor_id"
    t.integer "turn_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "current_hand_republic_policy_count"
    t.integer "current_hand_separatist_policy_count"
  end

  create_table "players", force: :cascade do |t|
    t.string "game_id"
    t.string "user_id"
    t.integer "turn_number"
    t.boolean "is_dead"
    t.string "identity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "votes", force: :cascade do |t|
    t.string "player_id"
    t.string "game_id"
    t.integer "turn_number"
    t.boolean "in_favor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
