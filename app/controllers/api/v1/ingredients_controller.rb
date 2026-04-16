class Api::V1::IngredientsController < ApplicationController
  def index
    ingredients = current_restaurant.ingredients.order(:name)

    if params[:search].present?
      query = "%#{params[:search].strip.downcase}%"
      ingredients = ingredients.where("LOWER(name) LIKE ?", query)
    end

    if params[:simple] == "true"
      render json: ingredients.select(:id, :name)
      return
    end

    render json: ingredients
  end

  def show
    ingredient = current_restaurant.ingredients.find(params[:id])
    render json: ingredient
  end

  def create
    ingredient = current_restaurant.ingredients.new(ingredient_params)

    if ingredient.save
      render json: ingredient, status: :created
    else
      render json: { errors: ingredient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    ingredient = current_restaurant.ingredients.find(params[:id])

    if ingredient.update(ingredient_params)
      render json: ingredient
    else
      render json: { errors: ingredient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    ingredient = current_restaurant.ingredients.find(params[:id])

    if ingredient.products.any?
      render json: { error: "Cannot delete ingredient that has associated products" }, status: :unprocessable_entity
      return
    end

    ingredient.destroy

    head :no_content
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name, :unit)
  end
end
