FactoryBot.define do
  factory :recipe do
    name { "Quesadilla" }
    recipe_type { "menu_item" }
    restaurant
  end
end
