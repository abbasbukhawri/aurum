class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :variant

  delegate :product, to: :variant

  validates :quantity, numericality: { greater_than: 0 }

  def price_cents
    variant.price_cents_effective
  end

  def total_cents
    price_cents * quantity
  end
end
