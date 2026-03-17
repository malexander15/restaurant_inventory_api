class Product < ApplicationRecord
  enum unit: { oz: 0, pcs: 1 }

  has_many :recipe_ingredients, as: :ingredient
  belongs_to :restaurant
  belongs_to :product_category, optional: true
  belongs_to :ingredient, optional: true

  validates :name, presence: true
  validates :unit, presence: true
  validates :ingredient, presence: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :barcode, uniqueness: { scope: :restaurant_id }, allow_nil: true
  validate :ingredient_belongs_to_restaurant

  before_validation :ensure_ingredient

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

  def ensure_ingredient
    return if ingredient.present? || restaurant.nil?

    self.ingredient = restaurant.ingredients.find_or_create_by(
      name: name,
      unit: unit
    )
  end

  def ingredient_belongs_to_restaurant
    return unless ingredient.present? && restaurant.present?

    unless ingredient.restaurant_id == restaurant_id
      errors.add(:ingredient_id, "must belong to the same restaurant")
    end
  end
end
