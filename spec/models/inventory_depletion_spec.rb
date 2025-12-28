require "rails_helper"

RSpec.describe "Inventory Depletion" do
  it "depletes product inventory when a menu item is sold" do
    cheese = Product.create!(
      name: "Cheese",
      unit: :oz,
      stock_quantity: 100
    )

    quesadilla = Recipe.create!(
      name: "Quesadilla",
      recipe_type: "menu_item"
    )

    RecipeIngredient.create!(
      recipe: quesadilla,
      ingredient: cheese,
      quantity: 10
    )

    expect {
      quesadilla.deplete_inventory!(3)
    }.to change { cheese.reload.stock_quantity }.from(100).to(70)
  end

  it "recursively depletes inventory through prepped items" do
    raw_chicken = Product.create!(
      name: "Raw Chicken",
      unit: :oz,
      stock_quantity: 200
    )

    grilled_chicken = Recipe.create!(
      name: "Grilled Chicken",
      recipe_type: "prepped_item"
    )

    RecipeIngredient.create!(
      recipe: grilled_chicken,
      ingredient: raw_chicken,
      quantity: 20
    )

    quesadilla = Recipe.create!(
      name: "Chicken Quesadilla",
      recipe_type: "menu_item"
    )

    RecipeIngredient.create!(
      recipe: quesadilla,
      ingredient: grilled_chicken,
      quantity: 1
    )

    expect {
      quesadilla.deplete_inventory!(2)
    }.to change { raw_chicken.reload.stock_quantity }.from(200).to(160)
  end

  it "raises an error when inventory is insufficient" do
    cheese = Product.create!(
      name: "Cheese",
      unit: :oz,
      stock_quantity: 10
    )

    quesadilla = Recipe.create!(
      name: "Quesadilla",
      recipe_type: "menu_item"
    )

    RecipeIngredient.create!(
      recipe: quesadilla,
      ingredient: cheese,
      quantity: 8
    )

    expect {
      quesadilla.deplete_inventory!(2)
    }.to raise_error(StandardError, /Not enough stock/)
  end

  it "does not partially deplete inventory when one ingredient fails" do
    cheese = Product.create!(name: "Cheese", unit: :oz, stock_quantity: 100)
    chicken = Product.create!(name: "Chicken", unit: :oz, stock_quantity: 5)

    recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")

    RecipeIngredient.create!(recipe:, ingredient: cheese, quantity: 10)
    RecipeIngredient.create!(recipe:, ingredient: chicken, quantity: 10)

    expect {
      recipe.deplete_inventory!(1)
    }.to raise_error(StandardError)

    expect(cheese.reload.stock_quantity).to eq(100)
    expect(chicken.reload.stock_quantity).to eq(5)
  end


end
