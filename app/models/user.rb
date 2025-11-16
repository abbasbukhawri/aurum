class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :trackable

  has_one :wishlist, dependent: :destroy
  has_many :carts,  dependent: :nullify
  has_many :orders, dependent: :nullify

  enum :role,
    customer: "customer",
    admin:    "admin"
  

  before_create :generate_auth_token

  def generate_auth_token
    self.auth_token ||= SecureRandom.hex(20)
  end

  def reset_auth_token!
    update!(auth_token: SecureRandom.hex(20))
  end

  def full_name
    [first_name, last_name].compact.join(" ")
  end
end
