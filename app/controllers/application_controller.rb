class ApplicationController < ActionController::API
  before_action :authorize_request

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
    @current_restaurant ||= Restaurant.find(decoded_token[:restaurant_id])
  end
end
