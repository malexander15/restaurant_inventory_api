class RefactorRecipeIngredientsToUseIngredients < ActiveRecord::Migration[7.0]
  def up
    # Update RecipeIngredients that point to Products to point to their Ingredients instead
    RecipeIngredient.where(ingredient_type: 'Product').find_each do |ri|
      product = Product.find_by(id: ri.ingredient_id)
      next unless product&.ingredient_id.present?

      ri.update!(
        ingredient_id: product.ingredient_id,
        ingredient_type: 'Ingredient'
      )
    end
  end

  def down
    # Revert RecipeIngredients that point to Ingredients back to their Products
    # This is complex because multiple Products can have the same Ingredient
    # We'll need to make a best-effort attempt to find a suitable Product
    RecipeIngredient.where(ingredient_type: 'Ingredient').find_each do |ri|
      ingredient = Ingredient.find_by(id: ri.ingredient_id)
      next unless ingredient

      # Find a Product with this Ingredient (prefer one with stock)
      product = Product.where(ingredient_id: ingredient.id)
                       .where(restaurant_id: ingredient.restaurant_id)
                       .order(stock_quantity: :desc)
                       .first

      next unless product

      ri.update!(
        ingredient_id: product.id,
        ingredient_type: 'Product'
      )
    end
  end
end
