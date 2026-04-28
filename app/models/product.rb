class Product < ApplicationRecord
  enum unit: { oz: 0, pcs: 1 }

  has_many :recipe_ingredients, as: :ingredient
  belongs_to :restaurant
  belongs_to :product_category, optional: true
  belongs_to :ingredient
  validates :name, presence: true
  validates :unit, presence: true
  validates :ingredient, presence: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :barcode, uniqueness: { scope: :restaurant_id }, allow_nil: true
  validate :ingredient_belongs_to_restaurant
  validate :unit_matches_ingredient

  def below_par?
    return false unless par_level.present?
    stock_quantity < par_level
  end

  def replenish!(qty)
    qty = qty.to_f
    raise ArgumentError, "Quantity must be greater than zero" if qty <= 0
    increment!(:stock_quantity, qty)
  end

  private

  def ingredient_belongs_to_restaurant
    return unless ingredient.present? && restaurant.present?

    unless ingredient.restaurant_id == restaurant_id
      errors.add(:ingredient_id, "must belong to the same restaurant")
    end
  end

  def unit_matches_ingredient
    return unless ingredient.present? && unit.present?

    if ingredient.unit != unit
      errors.add(:unit, "must match the unit of the associated ingredient") if ingredient.unit != unit
    end
  end
end
