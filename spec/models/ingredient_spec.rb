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
  end
end
