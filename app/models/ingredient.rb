class Ingredient < ApplicationRecord
  enum unit: { oz: 0, pcs: 1 }

  belongs_to :restaurant
  has_many :products

  validates :name, presence: true
  validates :unit, presence: true
end
