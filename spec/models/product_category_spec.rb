require "rails_helper"

RSpec.describe ProductCategory, type: :model do
  let(:restaurant) { create(:restaurant) }

  it "is valid with a name and restaurant" do
    category = ProductCategory.new(name: "Produce", restaurant: restaurant)
    expect(category).to be_valid
  end

  it "is invalid without a name" do
    category = ProductCategory.new(restaurant: restaurant)
    expect(category).not_to be_valid
  end

  it "belongs to a restaurant" do
    category = ProductCategory.create!(name: "Produce", restaurant: restaurant)
    expect(category.restaurant).to eq(restaurant)
  end
end