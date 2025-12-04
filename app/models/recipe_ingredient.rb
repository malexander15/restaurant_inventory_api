class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient, polymorphic: true

  validates :quantity, numericality: { greater_than: 0 }
end
