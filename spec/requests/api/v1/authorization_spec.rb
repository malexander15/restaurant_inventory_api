require "rails_helper"

RSpec.describe "Authorization", type: :request do
  it "blocks access without a token" do
    get "/api/v1/products"

    expect(response).to have_http_status(:unauthorized)
  end

  it "blocks access with an invalid token" do
    get "/api/v1/products",
        headers: { "Authorization" => "Bearer BADTOKEN" }

    expect(response).to have_http_status(:unauthorized)
  end
end
