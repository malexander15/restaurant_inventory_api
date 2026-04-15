class Recipe < ApplicationRecord
    enum recipe_type: { prepped_item: 0, menu_item: 1 }
    validates :name, presence: true
    validates :recipe_type, presence: true

    belongs_to :restaurant

    has_many :recipe_ingredients, dependent: :destroy
    has_many :ingredients,
            through: :recipe_ingredients,
            source: :ingredient,
            source_type: 'Ingredient'

    has_many :subrecipes,
            through: :recipe_ingredients,
            source: :ingredient,
            source_type: 'Recipe'

    def deplete_inventory!(multiplier = 1)
    ApplicationRecord.transaction do
        recipe_ingredients.each do |ri|
        case ri.ingredient
        when Ingredient
            required_qty = ri.quantity * multiplier
            deplete_ingredient_stock!(ri.ingredient, required_qty)

        when Recipe
            ri.ingredient.deplete_inventory!(ri.quantity * multiplier)
        end
        end
    end
    end

    private

    def deplete_ingredient_stock!(ingredient, required_qty)
      # Find Products with this Ingredient that have stock, ordered by stock quantity (simple FIFO approximation)
      available_products = ingredient.products
                                   .where('stock_quantity > 0')
                                   .order(:created_at) # Simple FIFO by creation time

      remaining_qty = required_qty

      available_products.each do |product|
        break if remaining_qty <= 0

        available_stock = product.stock_quantity
        consume_qty = [remaining_qty, available_stock].min

        product.update!(stock_quantity: product.stock_quantity - consume_qty)
        remaining_qty -= consume_qty
      end

      if remaining_qty > 0
        raise StandardError, "Not enough stock"
      end
    end

end
