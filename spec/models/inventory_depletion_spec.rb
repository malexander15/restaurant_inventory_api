require 'rails_helper'

RSpec.describe "Inventory depletion", type: :model do
  it "depletes product ingredients directly" do
    cheese = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)
    recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")

    RecipeIngredient.create!(recipe: recipe, ingredient: cheese, quantity: 4)

    expect {
      recipe.deplete_inventory
    }.to change { cheese.reload.stock_quantity }.by(-4)
  end

  it "recursively depletes ingredients of sub-recipes" do
    raw = Product.create!(name: "Raw Chicken", unit: "oz", stock_quantity: 50)
    grilled = Recipe.create!(name: "Grilled Chicken", recipe_type: "prep")
    quesadilla = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")

    # Grilled chicken uses 10 oz raw chicken
    RecipeIngredient.create!(recipe: grilled, ingredient: raw, quantity: 10)

    # Quesadilla uses 1 portion of grilled chicken
    RecipeIngredient.create!(recipe: quesadilla, ingredient: grilled, quantity: 1)

    expect {
      quesadilla.deplete_inventory
    }.to change { raw.reload.stock_quantity }.by(-10)
  end

  it "raises an error if any ingredient (even nested) is insufficient" do
    raw = Product.create!(name: "Raw Chicken", unit: "oz", stock_quantity: 5)
    grilled = Recipe.create!(name: "Grilled Chicken", recipe_type: "prep")
    quesadilla = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")

    RecipeIngredient.create!(recipe: grilled, ingredient: raw, quantity: 10)
    RecipeIngredient.create!(recipe: quesadilla, ingredient: grilled, quantity: 1)

    expect {
      quesadilla.deplete_inventory
    }.to raise_error(/Insufficient stock/)
  end
end