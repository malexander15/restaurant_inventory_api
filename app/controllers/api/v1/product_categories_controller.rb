class Api::V1::ProductCategoriesController < ApplicationController
  def index
    categories = ProductCategory
      .where(restaurant_id: current_restaurant.id)
      .order(:name)

    render json: categories
  end

  def create
    normalized_name = category_params[:name].to_s.strip.titleize

    category = current_restaurant.product_categories.find_or_create_by!(
      name: normalized_name
    )

    render json: category, status: :created
  end

  private

  def category_params
    params.require(:product_category).permit(:name)
  end
end