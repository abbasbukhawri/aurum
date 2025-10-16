class Cart < ApplicationRecord
  enum :status, { active: 0, converted: 1, abandoned: 2 }, prefix: true
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy

  def subtotal_cents
    cart_items.sum(&:line_total_cents)
  end
end