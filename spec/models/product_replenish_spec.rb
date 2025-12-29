require 'rails_helper'
# spec/models/product_replenish_spec.rb
RSpec.describe "Product replenishment" do
  it "adds to stock quantity" do
    product = Product.create!(
      name: "Cheese",
      unit: "oz",
      stock_quantity: 10
    )

    product.increment!(:stock_quantity, 5)

    expect(product.reload.stock_quantity).to eq(15)
  end
end
