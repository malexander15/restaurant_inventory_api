FactoryBot.define do
  factory :recipe_ingredient do
    recipe { nil }
    product { nil }
    quantity { 1.5 }
  end
end
