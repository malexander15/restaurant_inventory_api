# lib/tasks/ci.rake
namespace :ci do
  desc "Seed required data for CI/E2E tests (idempotent)"
  task seed: :environment do
    email = ENV.fetch("CI_RESTAURANT_EMAIL", "admin@thebreakroom.com")
    password = ENV.fetch("CI_RESTAURANT_PASSWORD", "breakroom2025")
    name = ENV.fetch("CI_RESTAURANT_NAME", "CI Restaurant")

    puts "Seeding CI restaurant..."
    puts "- name: #{name}"
    puts "- email: #{email}"

    restaurant = Restaurant.find_or_initialize_by(email: email)
    restaurant.name = name

    if restaurant.new_record?
      restaurant.password = password
      restaurant.password_confirmation = password
    end

    restaurant.save!

    puts "✅ CI restaurant ready (id=#{restaurant.id})"

    puts "Seeding baseline ingredients..."
    cheese_ingredient = Ingredient.find_or_create_by!(
      restaurant: restaurant,
      name: "Cheese"
    ) do |i|
      i.unit = "oz"
    end

    puts "Cheese ingredient ready"

    puts "Seeding baseline products..."
    Product.find_or_create_by!(
      restaurant: restaurant,
      name: "Cheese"
    ) do |p|
      p.ingredient = cheese_ingredient
      p.unit = "oz"
      p.stock_quantity = 1000
      p.unit_cost = 0.25
      p.barcode = "CI-CHEESE-001"
    end

    puts "Cheese product ready"
  end
end
