require 'rails_helper'

RSpec.describe "Inventory depletion", type: :model do
  before(:each) do
    @cheese = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)
    @chicken = Product.create!(name: "Chicken", unit: "oz", stock_quantity: 20)
    
    @recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
    RecipeIngredient.create!(recipe: @recipe, product: @cheese, quantity: 4)
    RecipeIngredient.create!(recipe: @recipe, product: @chicken, quantity: 4)
  end

  it "subtracts ingredient quantities when a recipe is sold" do
    expect { @recipe.deplete_inventory }.to change { @cheese.reload.stock_quantity }.by(-4).and change { @chicken.reload.stock_quantity }.by(-4)
  end

  it "does not allow stock quantity to go below zero" do
    @cheese.update(stock_quantity: 2)
    expect { @recipe.deplete_inventory }.to raise_error("Not enough stock for Cheese")
  end
end
