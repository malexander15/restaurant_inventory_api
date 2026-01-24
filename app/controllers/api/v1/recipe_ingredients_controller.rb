class Api::V1::RecipeIngredientsController < ApplicationController
  before_action :set_recipe

  def create
    ri = @recipe.recipe_ingredients.new(recipe_ingredient_params)
    if ri.save
      render json: ri, status: :created
    else
      render json: { errors: ri.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    ri = @recipe.recipe_ingredients.find(params[:id])
    if ri.update(recipe_ingredient_params)
      render json: ri
    else
      render json: { errors: ri.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    ri = @recipe.recipe_ingredients.find(params[:id])
    ri.destroy
    head :no_content
  end

  private

  def set_recipe
    @recipe = current_restaurant.recipes.find(params[:recipe_id])
  end

  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(:ingredient_id, :ingredient_type, :quantity)
  end
end

