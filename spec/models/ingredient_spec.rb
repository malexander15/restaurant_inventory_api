require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe "validations" do
    it "requires a name" do
      ingredient = Ingredient.new(unit: :oz)
      expect(ingredient).not_to be_valid
    end

    it "requires a unit" do
      ingredient = Ingredient.new(name: "Vodka")
      expect(ingredient).not_to be_valid
    end

    it "validates uniqueness of name scoped to restaurant" do
      restaurant = create(:restaurant)
      create(:ingredient, restaurant: restaurant, name: "Romaine")

      duplicate = build(:ingredient, restaurant: restaurant, name: "Romaine")
      expect(duplicate).not_to be_valid
    end
  end

  describe "normalization" do
    it "normalizes name to title case" do
      ingredient = create(:ingredient, name: "romaine lettuce")
      expect(ingredient.reload.name).to eq("Romaine Lettuce")
    end

    it "strips whitespace from name" do
      ingredient = create(:ingredient, name: "  romaine  ")
      expect(ingredient.reload.name).to eq("Romaine")
    end
  end
end
