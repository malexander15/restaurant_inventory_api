require "rails_helper"

RSpec.describe "Products API", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:headers) { auth_headers(restaurant) }

  describe "GET /api/v1/products" do
    it "returns only the current restaurant's products" do
      create_list(:product, 2, restaurant: restaurant)
      create(:product)

      get "/api/v1/products", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(2)
    end
  end

  describe "GET /api/v1/products/:id" do
    it "returns a product owned by the restaurant" do
      product = create(:product, restaurant: restaurant)

      get "/api/v1/products/#{product.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(product.id)
    end

    it "does not allow access to another restaurant's product" do
      other_restaurant = create(:restaurant)
      product = create(:product, restaurant: other_restaurant)

      get "/api/v1/products/#{product.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  it "creates a product" do
    params = {
      product: {
        name: "Cheese",
        unit: "oz",
        stock_quantity: 10,
        unit_cost: 1.5
      }
    }.to_json

    expect {
      post "/api/v1/products",
          params: params,
          headers: headers.merge(
            "CONTENT_TYPE" => "application/json"
          )
    }.to change(Product, :count).by(1)

    expect(response).to have_http_status(:created)
  end

  describe "PATCH /api/v1/products/:id" do
    it "updates a product" do
      product = create(:product, restaurant: restaurant)

      patch "/api/v1/products/#{product.id}",
            params: { product: { name: "Updated Name" } }.to_json,
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(product.reload.name).to eq("Updated Name")
    end
  end

  describe "DELETE /api/v1/products/:id" do
    it "deletes a product" do
      product = create(:product, restaurant: restaurant)

      expect {
        delete "/api/v1/products/#{product.id}", headers: headers
      }.to change { Product.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "POST /api/v1/products/:id/replenish" do
    it "replenishes inventory" do
      product = create(:product, restaurant: restaurant, stock_quantity: 10)

      post "/api/v1/products/#{product.id}/replenish",
           params: { quantity: 5 }.to_json,
           headers: headers

      expect(response).to have_http_status(:ok)
      expect(product.reload.stock_quantity).to eq(15)
    end

    it "returns error for invalid quantity" do
      product = create(:product, restaurant: restaurant)

      post "/api/v1/products/#{product.id}/replenish",
          params: { quantity: 0 }.to_json,
          headers: headers.merge(
            "CONTENT_TYPE" => "application/json"
          )

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /api/v1/products/by-barcode/:barcode" do
    it "returns product when barcode exists" do
      product = create(:product, restaurant: restaurant, barcode: "12345")

      get "/api/v1/products/by-barcode/12345", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(product.id)
    end

    it "returns 404 when barcode is not found" do
      get "/api/v1/products/by-barcode/NOPE", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
