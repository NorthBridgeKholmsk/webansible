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

ActiveRecord::Schema[7.0].define(version: 2024_03_19_101356) do
  create_table "groups", force: :cascade do |t|
    t.text "name"
    t.binary "variables"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "host_roles", force: :cascade do |t|
    t.text "id_role"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "host_types", force: :cascade do |t|
    t.text "id_type"
    t.text "name"
  end

  create_table "hosts", force: :cascade do |t|
    t.text "hostname"
    t.text "address"
    t.text "login"
    t.text "password"
    t.integer "host_type_id"
    t.text "os"
    t.text "host_role"
    t.integer "group_id"
    t.index ["group_id"], name: "index_hosts_on_group_id"
    t.index ["host_type_id"], name: "index_hosts_on_host_type_id"
  end

  create_table "playbooks", force: :cascade do |t|
    t.text "name"
    t.text "comment"
    t.text "lin_tasks"
    t.text "win_tasks"
  end

  create_table "users", force: :cascade do |t|
    t.string "login"
    t.string "encrypted_password"
    t.string "salt"
    t.string "first_name"
    t.string "last_name"
  end

end
