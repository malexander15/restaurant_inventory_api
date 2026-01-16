class Api::V1::RestaurantsController < ApplicationController
  def me
    render json: {
      id: current_restaurant.id,
      name: current_restaurant.name,
      email: current_restaurant.email,
      logo_url: current_restaurant.logo_url
    }
  end

  def update
    if current_restaurant.update(restaurant_params)
      render json: current_restaurant
    else
      render json: { errors: current_restaurant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def restaurant_params
    params.permit(:name, :email, :logo_url)
  end
end
