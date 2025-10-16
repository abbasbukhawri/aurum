class Variant < ApplicationRecord
  belongs_to :product
  has_many_attached :images

  validates :sku, presence: true, uniqueness: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  monetize :price_cents, with_model_currency: :currency, allow_nil: true

  def currency
    product.currency
  end

  def price
    (price_cents || product.base_price_cents)
  end
end
