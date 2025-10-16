class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :variant

  validates :quantity, numericality: { greater_than: 0 }

  def unit_price_cents
    variant.price
  end

  def line_total_cents
    unit_price_cents * quantity
  end
end