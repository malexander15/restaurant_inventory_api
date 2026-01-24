module AuthHelper
  def auth_headers(restaurant)
    token = JsonWebToken.encode(restaurant_id: restaurant.id)

    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  end
end