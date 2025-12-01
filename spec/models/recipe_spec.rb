require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      recipe = Recipe.new(name: "Quesadilla", recipe_type: "menu_item")
      expect(recipe).to be_valid
    end

    it "requires a name" do
      recipe = Recipe.new(name: nil, recipe_type: "menu_item")
      expect(recipe).not_to be_valid
      expect(recipe.errors[:name]).to include("can't be blank")
    end

    it "requires a recipe_type" do
      recipe = Recipe.new(name: "Quesadilla", recipe_type: nil)
      expect(recipe).not_to be_valid
      expect(recipe.errors[:recipe_type]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "can have many recipe_ingredients" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      cheese = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)
      chicken = Product.create!(name: "Chicken", unit: "oz", stock_quantity: 20)

      # associate products with recipe through RecipeIngredient
      ri1 = RecipeIngredient.create!(recipe: recipe, product: cheese, quantity: 4)
      ri2 = RecipeIngredient.create!(recipe: recipe, product: chicken, quantity: 4)

      expect(recipe.recipe_ingredients.count).to eq(2)
      expect(recipe.products).to include(cheese, chicken)
    end
  end
end
