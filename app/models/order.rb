class Order < ApplicationRecord
  enum :status, { draft: 0, placed: 1, paid: 2, shipped: 3, completed: 4, canceled: 5 }, prefix: true
  enum :payment_status, { pending: 0, authorized: 1, captured: 2, failed: 3, refunded: 4 }, prefix: true
  enum :shipping_status, { not_required: 0, pending: 1, in_transit: 2, delivered: 3 }, prefix: true

  belongs_to :user, optional: true
  belongs_to :cart, optional: true
  belongs_to :billing_address, class_name: 'Address', optional: true
  belongs_to :shipping_address, class_name: 'Address', optional: true

  has_many :order_items, dependent: :destroy

  before_create :assign_number

  def assign_number
    self.number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end
