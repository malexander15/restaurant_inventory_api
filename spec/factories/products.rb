FactoryBot.define do
  factory :product do
    name { "Cheese" }
    unit { "oz" }
    stock_quantity { 10 }
    unit_cost { 1.0 }
    association :restaurant
  end
end
