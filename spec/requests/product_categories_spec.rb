require 'rails_helper'

RSpec.describe "ProductCategories", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/product_categories/index"
      expect(response).to have_http_status(:success)
    end
  end

end
