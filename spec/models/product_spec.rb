require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      product = Product.new(
        name: "Cheese",
        unit: "oz",
        stock_quantity: 10.0,
        upc_code: "123456789012"
      )

      expect(product).to be_valid
    end

    it "requires a name" do
      product = Product.new(name: nil)
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("can't be blank")
    end

    it "requires a unit" do
      product = Product.new(unit: nil)
      expect(product).not_to be_valid
      expect(product.errors[:unit]).to include("can't be blank")
    end

    it "requires stock_quantity to be numeric" do
      product = Product.new(stock_quantity: "not a number")
      expect(product).not_to be_valid
    end

    it "defaults stock_quantity to 0" do
      product = Product.new(name: "Tomatoes", unit: "oz")
      product.validate
      expect(product.stock_quantity).to eq(0)
    end
  end
end
