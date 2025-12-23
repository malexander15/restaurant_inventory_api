class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient, polymorphic: true

  validates :quantity, numericality: { greater_than: 0 }

  validate :ingredient_cannot_be_menu_item

  private

  def ingredient_cannot_be_menu_item
    return unless ingredient.is_a?(Recipe)
    return unless ingredient.menu_item?

    errors.add(:ingredient, "menu items cannot be used as ingredients")
  end

end
