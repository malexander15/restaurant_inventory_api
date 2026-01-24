RSpec.describe Restaurant, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      restaurant = build(:restaurant)
      expect(restaurant).to be_valid
    end

    it "requires a name" do
      restaurant = build(:restaurant, name: nil)
      expect(restaurant).not_to be_valid
    end

    it "requires an email" do
      restaurant = build(:restaurant, email: nil)
      expect(restaurant).not_to be_valid
    end

    it "requires a unique email" do
      create(:restaurant, email: "test@example.com")
      dupe = build(:restaurant, email: "test@example.com")

      expect(dupe).not_to be_valid
    end
  end

  describe "associations" do
    it "has many products" do
      restaurant = create(:restaurant)
      product = create(:product, restaurant: restaurant)

      expect(restaurant.products).to include(product)
    end

    it "has many recipes" do
      restaurant = create(:restaurant)
      recipe = create(:recipe, restaurant: restaurant)

      expect(restaurant.recipes).to include(recipe)
    end
  end

  describe "#password_reset_expired?" do
    it "returns false when reset is recent" do
      restaurant = create(:restaurant, reset_password_sent_at: 30.minutes.ago)
      expect(restaurant.password_reset_expired?).to eq(false)
    end

    it "returns true when reset is expired" do
      restaurant = create(:restaurant, reset_password_sent_at: 3.hours.ago)
      expect(restaurant.password_reset_expired?).to eq(true)
    end
  end

  describe "#generate_password_reset!" do
    it "sets reset token and timestamp" do
      restaurant = create(:restaurant)

      token = restaurant.generate_password_reset!

      restaurant.reload

      expect(token).to be_present
      expect(restaurant.reset_password_token).to be_present
      expect(restaurant.reset_password_sent_at).to be_within(5.seconds).of(Time.current)
    end
  end
  end
