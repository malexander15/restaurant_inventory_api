class Api::V1::PasswordResetsController < ApplicationController
  skip_before_action :authorize_request

  def create
    restaurant = Restaurant.find_by(email: params[:email])

    return head :ok unless restaurant
    # 👆 prevents email enumeration

    token = restaurant.generate_password_reset!

    reset_url = "#{ENV.fetch("FRONTEND_URL")}/reset-password?token=#{token}"

    render json: {
      message: "Password reset generated",
      reset_url: reset_url # 👈 DEV ONLY
    }
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
end
