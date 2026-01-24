require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  let(:restaurant) { create(:restaurant) }

  describe "validations" do
    it "is valid with a product ingredient" do
      recipe = create(:recipe, restaurant: restaurant)
      product = create(:product, restaurant: restaurant)

      ri = described_class.new(
        recipe: recipe,
        ingredient: product,
        quantity: 4
      )

      expect(ri).to be_valid
    end

    it "is valid with a recipe ingredient (prepped item)" do
      parent = create(:recipe, restaurant: restaurant)
      sub_recipe = create(
        :recipe,
        restaurant: restaurant,
        recipe_type: "prepped_item"
      )

      ri = described_class.new(
        recipe: parent,
        ingredient: sub_recipe,
        quantity: 1
      )

      expect(ri).to be_valid
    end

    it "requires quantity to be positive" do
      recipe = create(:recipe, restaurant: restaurant)
      product = create(:product, restaurant: restaurant)

      ri = described_class.new(
        recipe: recipe,
        ingredient: product,
        quantity: -1
      )

      expect(ri).not_to be_valid
    end

    it "does not allow menu items to be ingredients" do
      menu_item = create(
        :recipe,
        restaurant: restaurant,
        recipe_type: "menu_item"
      )

      parent = create(:recipe, restaurant: restaurant)

      ri = described_class.new(
        recipe: parent,
        ingredient: menu_item,
        quantity: 1
      )

      expect(ri).not_to be_valid
      expect(ri.errors[:ingredient])
        .to include("menu items cannot be used as ingredients")
    end
  end

  describe "associations" do
    it "belongs to a recipe" do
      ri = create(
        :recipe_ingredient,
        recipe: create(:recipe, restaurant: restaurant),
        ingredient: create(:product, restaurant: restaurant)
      )

      expect(ri.recipe).to be_present
    end

    it "belongs to a polymorphic ingredient" do
      product = create(:product, restaurant: restaurant)
      ri = create(
        :recipe_ingredient,
        recipe: create(:recipe, restaurant: restaurant),
        ingredient: product
      )

      expect(ri.ingredient).to eq(product)
    end
  end
end
