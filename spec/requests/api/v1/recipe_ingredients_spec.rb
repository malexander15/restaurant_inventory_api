require "rails_helper"

RSpec.describe "RecipeIngredients API", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:headers) { auth_headers(restaurant) }

  describe "POST /api/v1/recipes/:recipe_id/recipe_ingredients" do
    it "creates a recipe ingredient" do
      recipe = create(:recipe, restaurant: restaurant)
      product = create(:product, restaurant: restaurant)

      expect {
        post "/api/v1/recipes/#{recipe.id}/recipe_ingredients",
             params: {
               recipe_ingredient: {
                 ingredient_id: product.id,
                 ingredient_type: "Product",
                 quantity: 2
               }
             }.to_json,
             headers: headers.merge("Content-Type" => "application/json")
      }.to change { RecipeIngredient.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns 422 for invalid quantity" do
      recipe = create(:recipe, restaurant: restaurant)
      product = create(:product, restaurant: restaurant)

      post "/api/v1/recipes/#{recipe.id}/recipe_ingredients",
           params: {
             recipe_ingredient: {
               ingredient_id: product.id,
               ingredient_type: "Product",
               quantity: 0
             }
           }.to_json,
           headers: headers.merge("Content-Type" => "application/json")

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "does not allow adding ingredients to another restaurant's recipe" do
      other_restaurant = create(:restaurant)
      recipe = create(:recipe, restaurant: other_restaurant)
      product = create(:product, restaurant: restaurant)

      post "/api/v1/recipes/#{recipe.id}/recipe_ingredients",
           params: {
             recipe_ingredient: {
               ingredient_id: product.id,
               ingredient_type: "Product",
               quantity: 1
             }
           }.to_json,
           headers: headers.merge("Content-Type" => "application/json")

      expect(response).to have_http_status(:not_found)
    end
  end
end