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
      product = Product.new(name: "Cheese", unit: :oz, stock_quantity: 10, unit_cost: 1)
      product.unit_cost = -5
      expect(product).not_to be_valid
    end

    it "validates uniqueness of barcode" do
      restaurant = create(:restaurant)

      create(
        :product,
        restaurant: restaurant,
        name: "Cheese",
        barcode: "12345"
      )

      dupe = build(
        :product,
        restaurant: restaurant,
        name: "Chicken",
        barcode: "12345"
      )

      expect(dupe).not_to be_valid
    end
  end

  describe "#below_par?" do
    it "returns false if par_level is nil" do
      product = create(:product, stock_quantity: 20, par_level: nil)
      expect(product.below_par?).to eq(false)
    end

    it "returns true when below par level" do
      product = create(:product, stock_quantity: 20, par_level: 30)
      expect(product.below_par?).to eq(true)
    end

    it "returns false when above par level" do
      product = create(:product, stock_quantity: 40, par_level: 30)
      expect(product.below_par?).to eq(false)
    end
  end
  
  describe "#replenish!" do
    it "adds to stock quantity" do
      product = create(:product, stock_quantity: 10)

      product.replenish!(5)

      expect(product.stock_quantity).to eq(15)
    end

    it "raises an error for zero quantity" do
      product = create(:product, stock_quantity: 10)

      expect {
        product.replenish!(0)
      }.to raise_error(ArgumentError, "Quantity must be greater than zero")
    end

    it "raises an error for negative quantity" do
      product = create(:product, stock_quantity: 10)

      expect {
        product.replenish!(-3)
      }.to raise_error(ArgumentError)
    end
  end
end
