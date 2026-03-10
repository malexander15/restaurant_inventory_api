require "rails_helper"

RSpec.describe "ProductCategories", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:headers) { auth_headers(restaurant) }
  
  describe "GET /api/v1/product_categories" do
    let!(:category1) { create(:product_category, name: "Produce", restaurant: restaurant) }
    let!(:category2) { create(:product_category, name: "Meat", restaurant: restaurant) }

    it "returns categories for authenticated restaurants" do
      get "/api/v1/product_categories", headers: headers

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response.size).to eq(2)
      expect(json_response[0]["name"]).to eq("Produce").or eq("Meat")
    end
  end
end