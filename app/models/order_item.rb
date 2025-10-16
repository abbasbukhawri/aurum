class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :variant

  before_validation :capture_snapshot, on: :create

  def capture_snapshot
    self.name  ||= variant.product.name
    self.sku   ||= variant.sku
    self.price_cents ||= variant.price
    self.total_cents ||= price_cents * quantity
  end
end