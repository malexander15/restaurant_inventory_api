require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "validations" do
    it "requires a name" do
      product = Product.new(unit: :oz, stock_quantity: 10, unit_cost: 1)
      expect(product).not_to be_valid
    end

    it "requires a unit" do
      product = Product.new(name: "Cheese", stock_quantity: 10, unit_cost: 1)
      expect(product).not_to be_valid
    end

    it "requires non-negative stock_quantity" do
      product = Product.new(name: "Cheese", unit: :oz, stock_quantity: -1, unit_cost: 1)
      expect(product).not_to be_valid
    end

    it "requires non-negative unit_cost" do
      product = Product.new(name: "Cheese", unit: :oz, stock_quantity: 10, unit_cost: -1)
      expect(product).not_to be_valid
    end

    it "validates uniqueness of barcode" do
      Product.create!(name: "Cheese", unit: :oz, stock_quantity: 10, unit_cost: 1, barcode: "12345")

      dupe = Product.new(name: "Chicken", unit: :oz, stock_quantity: 10, unit_cost: 1, barcode: "12345")
      expect(dupe).not_to be_valid
    end
  end

  describe "#below_par?" do
    it "returns false if par_level is nil" do
      product = Product.create!(name: "Cheese", unit: :oz, stock_quantity: 20, unit_cost: 1)
      expect(product.below_par?).to eq(false)
    end

    it "returns true when below par level" do
      product = Product.create!(name: "Cheese", unit: :oz, stock_quantity: 20, unit_cost: 1, par_level: 30)
      expect(product.below_par?).to eq(true)
    end

    it "returns false when above par level" do
      product = Product.create!(name: "Cheese", unit: :oz, stock_quantity: 40, unit_cost: 1, par_level: 30)
      expect(product.below_par?).to eq(false)
    end
  end
end
