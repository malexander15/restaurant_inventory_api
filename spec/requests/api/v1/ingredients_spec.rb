require "rails_helper"

RSpec.describe "Ingredients API", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:headers) { auth_headers(restaurant) }

  describe "GET /api/v1/ingredients" do
    it "returns only the current restaurant's ingredients" do
      create_list(:ingredient, 2, restaurant: restaurant)
      create(:ingredient)

      get "/api/v1/ingredients", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(2)
    end

    it "filters ingredients by search term" do
      create(:ingredient, restaurant: restaurant, name: "Romaine")
      create(:ingredient, restaurant: restaurant, name: "Tomato")

      get "/api/v1/ingredients?search=roma", headers: headers

      expect(response).to have_http_status(:ok)
      results = JSON.parse(response.body)
      expect(results.length).to eq(1)
      expect(results.first["name"]).to eq("Romaine")
    end

    it "returns simple format when requested" do
      create(:ingredient, restaurant: restaurant, name: "Romaine")

      get "/api/v1/ingredients?simple=true", headers: headers

      expect(response).to have_http_status(:ok)
      results = JSON.parse(response.body)
      expect(results.first.keys).to eq(["id", "name"])
    end
  end

  describe "GET /api/v1/ingredients/:id" do
    it "returns an ingredient owned by the restaurant" do
      ingredient = create(:ingredient, restaurant: restaurant)

      get "/api/v1/ingredients/#{ingredient.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(ingredient.id)
    end

    it "does not allow access to another restaurant's ingredient" do
      other_restaurant = create(:restaurant)
      ingredient = create(:ingredient, restaurant: other_restaurant)

      get "/api/v1/ingredients/#{ingredient.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/ingredients" do
    it "creates an ingredient" do
      expect {
        post "/api/v1/ingredients",
             params: {
               ingredient: {
                 name: "Vodka",
                 unit: "oz"
               }
             }.to_json,
             headers: headers.merge("Content-Type" => "application/json")
      }.to change(Ingredient, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid params" do
      post "/api/v1/ingredients",
           params: { ingredient: { name: "" } }.to_json,
           headers: headers.merge("Content-Type" => "application/json")

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/ingredients/:id" do
    it "updates an ingredient" do
      ingredient = create(:ingredient, restaurant: restaurant)

      patch "/api/v1/ingredients/#{ingredient.id}",
            params: { ingredient: { name: "Updated Ingredient" } }.to_json,
            headers: headers.merge("Content-Type" => "application/json")

      expect(response).to have_http_status(:ok)
      expect(ingredient.reload.name).to eq("Updated Ingredient")
    end
  end

  describe "DELETE /api/v1/ingredients/:id" do
    it "deletes an ingredient" do
      ingredient = create(:ingredient, restaurant: restaurant)

      expect {
        delete "/api/v1/ingredients/#{ingredient.id}", headers: headers
      }.to change { Ingredient.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "does not delete an ingredient with associated products" do
      ingredient = create(:ingredient, restaurant: restaurant)
      create(:product, restaurant: restaurant, ingredient: ingredient)

      expect {
        delete "/api/v1/ingredients/#{ingredient.id}", headers: headers
      }.not_to change { Ingredient.count }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("Cannot delete ingredient that has associated products")
    end
  end
end
