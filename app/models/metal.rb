class Metal < ApplicationRecord
  has_many :products

  validates :name, presence: true
  validates :purity_karat,
            numericality: { greater_than: 0, allow_nil: true }
end
