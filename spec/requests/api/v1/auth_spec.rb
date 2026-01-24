require "rails_helper"

RSpec.describe "Auth API", type: :request do
  describe "POST /api/v1/signup" do
    it "creates a restaurant and returns a token" do
      post "/api/v1/signup", params: {
        name: "Test Restaurant",
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      }

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body)
      expect(body["token"]).to be_present
      expect(body["restaurant"]["email"]).to eq("test@example.com")
    end

    it "returns errors for invalid params" do
      post "/api/v1/signup", params: {
        name: "",
        email: "",
        password: ""
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /api/v1/login" do
    let!(:restaurant) do
      create(
        :restaurant,
        email: "login@test.com",
        password: "password",
        password_confirmation: "password"
      )
    end

    it "returns a token for valid credentials" do
      post "/api/v1/login", params: {
        email: "login@test.com",
        password: "password"
      }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["token"]).to be_present
      expect(body["restaurant"]["id"]).to eq(restaurant.id)
    end

    it "returns unauthorized for invalid credentials" do
      post "/api/v1/login", params: {
        email: "login@test.com",
        password: "wrong"
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
