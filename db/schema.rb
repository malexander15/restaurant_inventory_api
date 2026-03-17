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

ActiveRecord::Schema[7.0].define(version: 2026_03_17_023634) do
  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.integer "unit"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_ingredients_on_restaurant_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id", "name"], name: "index_product_categories_on_restaurant_id_and_name", unique: true
    t.index ["restaurant_id"], name: "index_product_categories_on_restaurant_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "barcode"
    t.integer "unit", null: false
    t.decimal "stock_quantity", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "unit_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.string "vendor"
    t.decimal "par_level", precision: 10, scale: 2
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "restaurant_id", null: false
    t.integer "product_category_id"
    t.integer "ingredient_id", null: false
    t.index ["ingredient_id"], name: "index_products_on_ingredient_id"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["restaurant_id", "barcode"], name: "index_products_on_restaurant_id_and_barcode", unique: true
    t.index ["restaurant_id"], name: "index_products_on_restaurant_id"
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
    t.integer "restaurant_id", null: false
    t.index ["restaurant_id"], name: "index_recipes_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "logo_url"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.index ["email"], name: "index_restaurants_on_email", unique: true
  end

  add_foreign_key "ingredients", "restaurants"
  add_foreign_key "product_categories", "restaurants"
  add_foreign_key "products", "ingredients"
  add_foreign_key "products", "product_categories"
  add_foreign_key "products", "restaurants"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "restaurants"
end
