require "rails_helper"

RSpec.describe "Recipes API", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:headers) { auth_headers(restaurant) }

  describe "GET /api/v1/recipes" do
    it "returns only the current restaurant's recipes" do
      create_list(:recipe, 2, restaurant: restaurant)
      create(:recipe) # other restaurant

      get "/api/v1/recipes", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(2)
    end
  end

  describe "GET /api/v1/recipes/:id" do
    it "returns a recipe owned by the restaurant" do
      recipe = create(:recipe, restaurant: restaurant)

      get "/api/v1/recipes/#{recipe.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(recipe.id)
    end

    it "does not allow access to another restaurant's recipe" do
      other_restaurant = create(:restaurant)
      recipe = create(:recipe, restaurant: other_restaurant)

      get "/api/v1/recipes/#{recipe.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/recipes" do
    it "creates a recipe" do
      expect {
        post "/api/v1/recipes",
             params: {
               recipe: {
                 name: "Quesadilla",
                 recipe_type: "menu_item"
               }
             }.to_json,
             headers: headers
      }.to change { Recipe.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid params" do
      post "/api/v1/recipes",
           params: { recipe: { name: "" } }.to_json,
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

    describe "PATCH /api/v1/recipes/:id" do
    it "updates a recipe" do
      recipe = create(:recipe, restaurant: restaurant)

      patch "/api/v1/recipes/#{recipe.id}",
            params: { recipe: { name: "Updated Recipe" } }.to_json,
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(recipe.reload.name).to eq("Updated Recipe")
    end
  end

  describe "DELETE /api/v1/recipes/:id" do
    it "deletes a recipe" do
      recipe = create(:recipe, restaurant: restaurant)

      expect {
        delete "/api/v1/recipes/#{recipe.id}", headers: headers
      }.to change { Recipe.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "POST /api/v1/recipes/:id/deplete" do
    it "depletes inventory" do
      cheese = create(:product, restaurant: restaurant, stock_quantity: 100)
      recipe = create(:recipe, restaurant: restaurant)

      create(:recipe_ingredient,
             recipe: recipe,
             ingredient: cheese,
             quantity: 10)

      post "/api/v1/recipes/#{recipe.id}/deplete",
           params: { quantity: 2 }.to_json,
           headers: headers

      expect(response).to have_http_status(:ok)
      expect(cheese.reload.stock_quantity).to eq(80)
    end

    it "returns error when inventory is insufficient" do
      cheese = create(:product, restaurant: restaurant, stock_quantity: 5)
      recipe = create(:recipe, restaurant: restaurant)

      create(:recipe_ingredient,
             recipe: recipe,
             ingredient: cheese,
             quantity: 10)

      post "/api/v1/recipes/#{recipe.id}/deplete",
           params: { quantity: 1 }.to_json,
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end





