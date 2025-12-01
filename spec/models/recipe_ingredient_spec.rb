require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      product = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)
      ri = RecipeIngredient.new(recipe: recipe, product: product, quantity: 4)

      expect(ri).to be_valid
    end

    it "requires a recipe" do
      product = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)
      ri = RecipeIngredient.new(recipe: nil, product: product, quantity: 4)

      expect(ri).not_to be_valid
      expect(ri.errors[:recipe]).to include("must exist")
    end

    it "requires a product" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      ri = RecipeIngredient.new(recipe: recipe, product: nil, quantity: 4)

      expect(ri).not_to be_valid
      expect(ri.errors[:product]).to include("must exist")
    end

    it "requires quantity to be numeric and positive" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      product = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)

      ri = RecipeIngredient.new(recipe: recipe, product: product, quantity: -2)
      expect(ri).not_to be_valid
      expect(ri.errors[:quantity]).to include("must be greater than 0")

      ri.quantity = "not a number"
      expect(ri).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a recipe and a product" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      product = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)
      ri = RecipeIngredient.create!(recipe: recipe, product: product, quantity: 4)

      expect(ri.recipe).to eq(recipe)
      expect(ri.product).to eq(product)
    end
  end
end

