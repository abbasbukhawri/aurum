class Address < ApplicationRecord
  belongs_to :user, optional: true

  enum :kind,
    billing:  "billing",
    shipping: "shipping",
    other:    "other"
  

  has_many :billing_orders,
           class_name: "Order",
           foreign_key: :billing_address_id,
           dependent: :nullify

  has_many :shipping_orders,
           class_name: "Order",
           foreign_key: :shipping_address_id,
           dependent: :nullify

  validates :full_name, :line1, :city, :country, presence: true
end
