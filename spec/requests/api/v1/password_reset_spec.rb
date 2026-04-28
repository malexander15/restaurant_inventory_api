require "rails_helper"

RSpec.describe "Password Reset API", type: :request do
  let!(:restaurant) do
    create(:restaurant, email: "reset@test.com")
  end

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "POST /api/v1/password/forgot" do
    it "generates a reset token and returns the reset link in test" do
      post "/api/v1/password/forgot", params: {
        email: "reset@test.com"
      }

      expect(response).to have_http_status(:ok)

      restaurant.reload
      expect(restaurant.reset_password_token).to be_present
      expect(restaurant.reset_password_sent_at).to be_present
      expect(JSON.parse(response.body)).to include("reset_url")
    end

    it "returns ok even if email does not exist (security)" do
      post "/api/v1/password/forgot", params: {
        email: "nope@test.com"
      }

      expect(response).to have_http_status(:ok)
    end

    it "sends an email instead of returning the link outside development/test" do
      allow(Rails.env).to receive(:development?).and_return(false)
      allow(Rails.env).to receive(:test?).and_return(false)

      post "/api/v1/password/forgot", params: {
        email: "reset@test.com"
      }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to have_key("reset_url")
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(ActionMailer::Base.deliveries.last.to).to eq(["reset@test.com"])
    end
  end

  describe "POST /api/v1/password/reset" do
    it "resets the password with a valid token" do
      token = restaurant.generate_password_reset!

      post "/api/v1/password/reset", params: {
        token: token,
        password: "newpassword",
        password_confirmation: "newpassword"
      }

      expect(response).to have_http_status(:ok)

      expect(
        restaurant.reload.authenticate("newpassword")
      ).to be_truthy
    end

    it "rejects an expired token" do
      restaurant.update!(
        reset_password_sent_at: 3.hours.ago
      )

      post "/api/v1/password/reset", params: {
        token: "expired",
        password: "newpassword"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
