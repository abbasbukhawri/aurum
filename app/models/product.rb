class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :metal, optional: true

  has_many :variants, dependent: :destroy
  has_many :product_gemstones, dependent: :destroy
  has_many :gemstones, through: :product_gemstones

  has_many_attached :images

  has_many :cart_items, through: :variants
  has_many :order_items, through: :variants

  has_many :carts, through: :cart_items
  has_many :orders, through: :order_items

  validates :name, :base_price_cents, :currency, presence: true

  scope :visible, -> { where(visible: true) }

  # No enum here – we are using STI via the 'type' column
end
