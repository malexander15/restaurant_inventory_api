class ApplicationController < ActionController::API
  before_action :authorize_request

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Not found" }, status: :not_found
  end

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    decoded = JsonWebToken.decode(token)
    @current_restaurant = Restaurant.find(decoded[:restaurant_id])
  rescue
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def current_restaurant
    @current_restaurant
  end
end
