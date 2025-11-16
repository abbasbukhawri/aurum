class ProductSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :description, :base_price_cents, :currency, :weight_grams, :visible

  belongs_to :metal
  belongs_to :category
  has_many :variants
end
