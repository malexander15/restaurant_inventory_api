class BackfillIngredientsForProducts < ActiveRecord::Migration[7.0]
  def up
    ActiveRecord::Base.transaction do
      Product.where(ingredient_id: nil).find_each do |product|
        ingredient = Ingredient.create!(
          name: product.name,
          unit: product.unit,
          restaurant: product.restaurant
        )
        product.update!(ingredient: ingredient)
      end
    end
  end

  def down
    # Remove all ingredients that are linked to products
    Ingredient.where(id: Product.pluck(:ingredient_id).compact).destroy_all
    # Reset ingredient_id to nil
    Product.update_all(ingredient_id: nil)
  end
end
