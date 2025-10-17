class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :quantity, :price_cents, :total_cents
end
