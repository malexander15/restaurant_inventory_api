class MakeProductIngredientRequired < ActiveRecord::Migration[7.0]
  def up
    # Ensure all existing products have an ingredient (should already be true after backfill)
    Product.where(ingredient_id: nil).find_each do |product|
      ingredient = product.restaurant.ingredients.find_or_create_by!(name: product.name, unit: product.unit)
      product.update!(ingredient: ingredient)
    end

    change_column_null :products, :ingredient_id, false
  end

  def down
    change_column_null :products, :ingredient_id, true
  end
end
