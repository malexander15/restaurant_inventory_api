class Api::V1::AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:login, :signup]

  def login
    restaurant = Restaurant.find_by(email: params[:email])

    if restaurant&.authenticate(params[:password])
      token = JsonWebToken.encode(restaurant_id: restaurant.id)

      render json: {
        token: token,
        restaurant: {
          id: restaurant.id,
          name: restaurant.name,
          email: restaurant.email
        }
      }
    else
      render json: { error: "Invalid email or password" },
             status: :unauthorized
    end
  end
end
