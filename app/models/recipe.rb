class Recipe < ApplicationRecord
    enum recipe_type: { prepped_item: 0, menu_item: 1 }
    validates :name, presence: true
    validates :recipe_type, presence: true
    
    has_many :recipe_ingredients
    has_many :ingredients,
            through: :recipe_ingredients,
            source: :ingredient,
            source_type: 'Product'

    has_many :subrecipes,
            through: :recipe_ingredients,
            source: :ingredient,
            source_type: 'Recipe'

  def deplete_inventory!(multiplier = 1)
    recipe_ingredients.each do |ri|
      case ri.ingredient
      when Product
        required_qty = ri.quantity * multiplier

        if ri.ingredient.stock_quantity < required_qty
          raise StandardError, "Not enough stock for #{ri.ingredient.name}"
        end

        ri.ingredient.update!(
          stock_quantity: ri.ingredient.stock_quantity - required_qty
        )

      when Recipe
        ri.ingredient.deplete_inventory!(ri.quantity * multiplier)
      end
    end
  end
end
