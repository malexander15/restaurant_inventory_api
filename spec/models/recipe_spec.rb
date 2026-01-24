require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:restaurant) { create(:restaurant) }

  describe "validations" do
    it "is valid with valid attributes" do
      recipe = build(
        :recipe,
        restaurant: restaurant,
        recipe_type: "menu_item"
      )

      expect(recipe).to be_valid
    end
  end

  describe "associations" do
    it "can have product ingredients" do
      recipe = create(:recipe, restaurant: restaurant)
      cheese = create(:product, restaurant: restaurant)

      create(
        :recipe_ingredient,
        recipe: recipe,
        ingredient: cheese,
        quantity: 4
      )

      expect(recipe.ingredients).to include(cheese)
    end

    it "can have recipe ingredients (prepped items)" do
      parent = create(:recipe, restaurant: restaurant)
      prep = create(
        :recipe,
        restaurant: restaurant,
        recipe_type: "prepped_item"
      )

      create(
        :recipe_ingredient,
        recipe: parent,
        ingredient: prep,
        quantity: 1
      )

      expect(parent.subrecipes).to include(prep)
    end
  end

  describe "#deplete_inventory!" do
    it "depletes product inventory when a menu item is sold" do
      cheese = create(
        :product,
        restaurant: restaurant,
        stock_quantity: 100
      )

      quesadilla = create(
        :recipe,
        restaurant: restaurant,
        recipe_type: "menu_item"
      )

      create(
        :recipe_ingredient,
        recipe: quesadilla,
        ingredient: cheese,
        quantity: 10
      )

      expect {
        quesadilla.deplete_inventory!(3)
      }.to change { cheese.reload.stock_quantity }.from(100).to(70)
    end

    it "recursively depletes inventory through prepped items" do
      raw_chicken = create(
        :product,
        restaurant: restaurant,
        stock_quantity: 200
      )

      grilled_chicken = create(
        :recipe,
        restaurant: restaurant,
        recipe_type: "prepped_item"
      )

      create(
        :recipe_ingredient,
        recipe: grilled_chicken,
        ingredient: raw_chicken,
        quantity: 20
      )

      quesadilla = create(
        :recipe,
        restaurant: restaurant,
        recipe_type: "menu_item"
      )

      create(
        :recipe_ingredient,
        recipe: quesadilla,
        ingredient: grilled_chicken,
        quantity: 1
      )

      expect {
        quesadilla.deplete_inventory!(2)
      }.to change { raw_chicken.reload.stock_quantity }.from(200).to(160)
    end

    it "raises an error when inventory is insufficient" do
      cheese = create(
        :product,
        restaurant: restaurant,
        stock_quantity: 10
      )

      quesadilla = create(:recipe, restaurant: restaurant)

      create(
        :recipe_ingredient,
        recipe: quesadilla,
        ingredient: cheese,
        quantity: 8
      )

      expect {
        quesadilla.deplete_inventory!(2)
      }.to raise_error(StandardError, /Not enough stock/)
    end

    it "does not partially deplete inventory when one ingredient fails" do
      cheese = create(
        :product,
        restaurant: restaurant,
        stock_quantity: 100
      )

      chicken = create(
        :product,
        restaurant: restaurant,
        stock_quantity: 5
      )

      recipe = create(:recipe, restaurant: restaurant)

      create(
        :recipe_ingredient,
        recipe: recipe,
        ingredient: cheese,
        quantity: 10
      )

      create(
        :recipe_ingredient,
        recipe: recipe,
        ingredient: chicken,
        quantity: 10
      )

      expect {
        recipe.deplete_inventory!(1)
      }.to raise_error(StandardError)

      expect(cheese.reload.stock_quantity).to eq(100)
      expect(chicken.reload.stock_quantity).to eq(5)
    end
  end
end
