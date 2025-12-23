require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      recipe = Recipe.new(name: "Quesadilla", recipe_type: "menu_item")
      expect(recipe).to be_valid
    end
  end

  describe "associations" do
    it "can have product ingredients" do
      recipe = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      cheese = Product.create!(name: "Cheese", unit: "oz", stock_quantity: 10)

      RecipeIngredient.create!(recipe: recipe, ingredient: cheese, quantity: 4)

      expect(recipe.ingredients).to include(cheese)
    end

    it "can have recipe ingredients (prepped items)" do
      parent = Recipe.create!(name: "Quesadilla", recipe_type: "menu_item")
      prep = Recipe.create!(name: "Grilled Chicken", recipe_type: "prepped_item")

      RecipeIngredient.create!(recipe: parent, ingredient: prep, quantity: 1)

      expect(parent.subrecipes).to include(prep)
    end
  end
end