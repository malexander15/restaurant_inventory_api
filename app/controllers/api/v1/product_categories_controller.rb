class Api::V1::ProductCategoriesController < ApplicationController
  def index
    categories = ProductCategory
      .where(restaurant_id: current_restaurant.id)
      .order(:name)
    render json: categories
  end
end
