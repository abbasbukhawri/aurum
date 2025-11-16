class Wishlist < ApplicationRecord
  belongs_to :user, optional: true

  has_many :wishlist_items, dependent: :destroy
  has_many :variants, through: :wishlist_items
  has_many :products, through: :variants

  enum :status,
    active:   "active",
    archived: "archived"

  def add_variant(variant)
    wishlist_items.find_or_create_by!(variant: variant)
  end

  def remove_variant(variant)
    wishlist_items.where(variant: variant).destroy_all
  end
end
