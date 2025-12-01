class Recipe < ApplicationRecord
    validates :name, presence: true
    validates :recipe_type, presence: true
    
    has_many :recipe_ingredients
    has_many :products, through: :recipe_ingredients
end
