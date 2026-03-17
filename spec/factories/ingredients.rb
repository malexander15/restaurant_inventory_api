FactoryBot.define do
  factory :ingredient do
    name { "Vodka" }
    unit { "oz" }
    association :restaurant
  end
end
