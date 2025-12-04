class Api::V1::RecipesController < ApplicationController
  def index
    recipes = Recipe.all
    render json: recipes, include: { recipe_ingredients: { include: :ingredient } }
  end

  def show
    recipe = Recipe.find(params[:id])
    render json: recipe, include: { recipe_ingredients: { include: :ingredient } }
  end

  def create
    recipe = Recipe.new(recipe_params)

    if recipe.save
      render json: recipe, status: :created
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    recipe = Recipe.find(params[:id])

    if recipe.update(recipe_params)
      render json: recipe
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    head :no_content
  end

  def deplete
    recipe = Recipe.find(params[:id])
    recipe.deplete_inventory

    render json: { message: "Inventory depleted successfully" }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :recipe_type)
  end
end
