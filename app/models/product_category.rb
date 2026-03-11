class ProductCategory < ApplicationRecord
  belongs_to :restaurant
  has_many :products, dependent: :nullify

  validates :name, presence: true, uniqueness: {scope: :restaurant_id}
end
