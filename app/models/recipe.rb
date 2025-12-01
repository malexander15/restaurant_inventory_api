class Recipe < ApplicationRecord
    validates :name, presence: true
    validates :recipe_type, presence: true
    
    has_many :recipe_ingredients
    has_many :products, through: :recipe_ingredients

    def deplete_inventory
        recipe_ingredients.each do |ri|
            if ri.quantity > ri.product.stock_quantity
                raise "Not enough stock for Cheese"
            else
                ri.product.update(stock_quantity: ri.product.stock_quantity - ri.quantity)
            end
        end
    end
end
