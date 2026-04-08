FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "Ingredient #{n}" }
    unit { "oz" }
    association :restaurant
  end
end
