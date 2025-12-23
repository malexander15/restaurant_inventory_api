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

ActiveRecord::Schema[7.0].define(version: 2025_12_23_005933) do
  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "barcode"
    t.integer "unit", null: false
    t.decimal "stock_quantity", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "unit_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.string "category"
    t.string "vendor"
    t.decimal "par_level", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barcode"], name: "index_products_on_barcode", unique: true
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ingredient_id"
    t.string "ingredient_type"
    t.index ["ingredient_type", "ingredient_id"], name: "index_recipe_ingredients_on_ingredient"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recipe_type", default: 0, null: false
  end

  add_foreign_key "recipe_ingredients", "recipes"
end
