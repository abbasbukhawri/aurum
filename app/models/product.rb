class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category, optional: true
  belongs_to :metal, optional: true
  has_many :variants, dependent: :destroy
  has_many :product_gemstones, dependent: :destroy
  has_many :gemstones, through: :product_gemstones

  has_many_attached :images
  validates :name, :currency, presence: true

  monetize :base_price_cents, with_model_currency: :currency

  scope :visible, -> { where(visible: true) }
end
