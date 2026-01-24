FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    quantity { 1.5 }

    trait :with_product do
      association :ingredient, factory: :product
    end

    trait :with_recipe do
      association :ingredient, factory: :recipe
    end
  end
end
