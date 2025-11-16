class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  belongs_to :variant

  delegate :product, to: :variant

  validates :variant_id, uniqueness: { scope: :wishlist_id }
end
