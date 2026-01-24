FactoryBot.define do
  factory :restaurant do
    name { "Test Restaurant" }
    sequence(:email) { |n| "restaurant#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
