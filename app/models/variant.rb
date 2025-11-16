class Variant < ApplicationRecord
  belongs_to :product

  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  validates :sku, presence: true, uniqueness: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  def full_name
    options_part =
      option_values.map { |k, v| "#{k}: #{v}" }.join(", ").presence
    [product.name, options_part].compact.join(" - ")
  end

  def currency
    product.currency
  end

  # cents (integer), with fallback to product
  def price_cents_effective
    price_cents || product.base_price_cents
  end

  # convenience alias
  def price
    price_cents_effective
  end
end
