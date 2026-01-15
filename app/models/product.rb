class Product < ApplicationRecord
  enum unit: { oz: 0, pcs: 1 }

  has_many :recipe_ingredients, as: :ingredient
  belongs_to :restaurant

  validates :name, presence: true
  validates :unit, presence: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :barcode, uniqueness: { scope: :restaurant_id }, allow_nil: true

  # Optional: useful helper
  def below_par?
    return false unless par_level.present?
    stock_quantity < par_level
  end
end
