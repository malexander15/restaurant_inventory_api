class Restaurant < ApplicationRecord
  has_secure_password

  has_many :products, dependent: :destroy
  has_many :recipes, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
