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

    #   Seed baseline products
    puts "Seeding baseline products..."


    Product.find_or_create_by!(
      restaurant: restaurant,
      name: "Cheese"
    ) do |p|
      p.unit = "oz"
      p.stock_quantity = 1000
      p.cost = 0.25
    end

    puts "Cheese product ready"
  end
end