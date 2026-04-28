class Api::V1::PasswordResetsController < ApplicationController
  skip_before_action :authorize_request

  def create
    restaurant = Restaurant.find_by(email: params[:email])

    return head :ok unless restaurant
    # 👆 prevents email enumeration

    token = restaurant.generate_password_reset!
    reset_url = password_reset_url_for(token)

    if expose_reset_url?
      render json: {
        message: "Password reset generated",
        reset_url: reset_url
      }
    else
      RestaurantMailer.password_reset(restaurant, reset_url).deliver_now

      render json: {
        message: "If an account with that email exists, a password reset email has been sent."
      }
    end
  end

  def update
    digest = Digest::SHA256.hexdigest(params[:token])
    restaurant = Restaurant.find_by(reset_password_token: digest)

    if restaurant.nil? || restaurant.password_reset_expired?
      return render json: { error: "Invalid or expired token" }, status: :unprocessable_entity
    end

    restaurant.update!(
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      reset_password_token: nil,
      reset_password_sent_at: nil
    )

    render json: { message: "Password reset successful" }
  end

  private

  def expose_reset_url?
    Rails.env.development? || Rails.env.test?
  end

  def password_reset_url_for(token)
    frontend_url = ENV.fetch("FRONTEND_URL", "http://localhost:3000")
    "#{frontend_url}/reset-password?token=#{token}"
  end
end
