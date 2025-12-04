class Recipe < ApplicationRecord
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

    def deplete_inventory
        recipe_ingredients.each do |ri|
            case ri.ingredient
            when Product
                product = ri.ingredient

                if ri.quantity > product.stock_quantity
                    raise StandardError.new("Insufficient stock for product #{product.name}")
                end

                product.update!(stock_quantity: product.stock_quantity - ri.quantity)
            when Recipe
                ri.ingredient.deplete_inventory
            end
        end
    end
end
