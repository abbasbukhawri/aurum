class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :variants, through: :cart_items
  has_many :products, through: :variants
  scope :converted, -> { where(status: 'converted') }

  enum :status, 
    active: "active",
    converted: "converted",
    abandoned: "abandoned",
    pending:   "pending"

  def total_cents
    cart_items.includes(:variant).sum { |item| item.total_cents }
  end
end
