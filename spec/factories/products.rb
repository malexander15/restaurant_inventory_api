FactoryBot.define do
  factory :product do
    name { Faker::Food.ingredient }
    unit { "oz" }
    stock_quantity { 10.0 }
    upc_code { Faker::Barcode.ean(12) }
  end
end