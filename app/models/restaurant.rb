class Restaurant < ApplicationRecord
  has_secure_password

  has_many :products, dependent: :destroy
  has_many :recipes, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def generate_password_reset!
    token = SecureRandom.urlsafe_base64(32)
    update!(
      reset_password_token: Digest::SHA256.hexdigest(token),
      reset_password_sent_at: Time.current
    )
    token
  end

  def password_reset_expired?
    reset_password_sent_at < 2.hours.ago
  end
end
