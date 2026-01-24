class Api::V1::RecipesController < ApplicationController
  def index
    recipes = current_restaurant.recipes

    # Filter by recipe type if requested
    if params[:recipe_type].present?
      recipes = recipes.where(recipe_type: params[:recipe_type])
    end

    # Lightweight payload (for selects / depletion)
    if params[:simple] == "true"
      render json: recipes.select(:id, :name)
      return
    end

    # Full payload
    recipes = recipes.includes(recipe_ingredients: :ingredient)

    render json: recipes.as_json(include: {
      recipe_ingredients: {
        include: {
          ingredient: {
            only: [:id, :name, :stock_quantity, :unit]
          }
        }
      }
    })
  end

  def show
    recipe = current_restaurant.recipes.find(params[:id])

    render json: recipe.as_json(include: {
      recipe_ingredients: {
        include: {
          ingredient: {
            only: [:id, :name, :stock_quantity, :unit]
          }
        }
      }
    })
  end

  def create
    recipe = current_restaurant.recipes.new(recipe_params)

    if recipe.save
      render json: recipe, status: :created
    else
      render json: { errors: recipe.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    recipe = current_restaurant.recipes.find(params[:id])

    if recipe.update(recipe_params)
      render json: recipe
    else
      render json: { errors: recipe.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    recipe = current_restaurant.recipes.find(params[:id])
    recipe.destroy

    head :no_content
  end

  def deplete
    recipe = current_restaurant.recipes.find(params[:id])
    quantity = params[:quantity].to_i

    recipe.deplete_inventory!(quantity)

    render json: { message: "Inventory depleted successfully" }
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
  end

    private

    def recipe_params
      params.require(:recipe).permit(:name, :recipe_type)
    end
  end
