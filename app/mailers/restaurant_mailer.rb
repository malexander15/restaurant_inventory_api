class RestaurantMailer < ApplicationMailer
  def password_reset(restaurant, reset_url)
    @restaurant = restaurant
    @reset_url = reset_url

    mail(to: restaurant.email, subject: "Reset your password")
  end
end
