class Ingredient < ApplicationRecord
  enum unit: { oz: 0, pcs: 1 }

  belongs_to :restaurant
  has_many :products

  validates :name, presence: true, uniqueness: { scope: :restaurant_id }
  validates :unit, presence: true

  before_save :normalize_name

  private

  def normalize_name
    self.name = name.strip.titleize if name.present?
  end
end
