class Order < ApplicationRecord
  belongs_to :user,             optional: true
  belongs_to :cart,             optional: true
  belongs_to :billing_address,  class_name: "Address", optional: true
  belongs_to :shipping_address, class_name: "Address", optional: true

  has_many :order_items, dependent: :destroy
  has_many :variants,    through: :order_items
  has_many :products,    through: :variants

  enum :status,
    pending:   "pending",
    confirmed: "confirmed",
    shipped:   "shipped",
    delivered: "delivered",
    cancelled: "cancelled"
  

  enum :payment_status,
    unpaid:   "unpaid",
    paid:     "paid",
    refunded: "refunded"


  def subtotal_cents
    order_items.sum(:total_cents)
  end

  def total_cents
    subtotal_cents + shipping_cents.to_i + tax_cents.to_i - discount_cents.to_i
  end
end
