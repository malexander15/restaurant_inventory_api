require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  describe "validations" do
    it "is valid with a product ingredient" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      product = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)

      ri = RecipeIngredient.new(recipe: recipe, ingredient: product, quantity: 4)
      expect(ri).to be_valid
    end

    it "is valid with a recipe ingredient" do
      parent = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      sub_recipe = Recipe.create!(name: "Grilled Chicken", recipe_type: "prep")

      ri = RecipeIngredient.new(recipe: parent, ingredient: sub_recipe, quantity: 1)
      expect(ri).to be_valid
    end

    it "requires quantity to be positive" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      product = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)

      ri = RecipeIngredient.new(recipe: recipe, ingredient: product, quantity: -1)
      expect(ri).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a recipe" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      product = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)

      ri = RecipeIngredient.create!(recipe: recipe, ingredient: product, quantity: 4)
      expect(ri.recipe).to eq(recipe)
    end

    it "belongs to a polymorphic ingredient" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      product = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)

      ri = RecipeIngredient.create!(recipe: recipe, ingredient: product, quantity: 4)
      expect(ri.ingredient).to eq(product)
    end
  end
end
