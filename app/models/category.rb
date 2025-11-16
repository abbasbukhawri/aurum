class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :parent, class_name: "Category", optional: true
  has_many :children,
           class_name: "Category",
           foreign_key: :parent_id,
           dependent: :nullify

  has_many :products

  validates :name, presence: true

  default_scope { order(position: :asc, name: :asc) }
end
