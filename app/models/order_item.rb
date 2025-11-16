class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :variant
  has_one :product, through: :variant

  before_validation :capture_snapshot, on: :create

  def capture_snapshot
    self.name        ||= variant.product.name
    self.sku         ||= variant.sku
    self.price_cents ||= variant.price_cents_effective
    self.total_cents ||= price_cents * quantity
  end
end
