class Gemstone < ApplicationRecord
  has_many :product_gemstones, dependent: :destroy
  has_many :products, through: :product_gemstones

  enum :kind,
    natural:   "natural",
    lab:       "lab",
    synthetic: "synthetic"

  validates :name, presence: true
end
