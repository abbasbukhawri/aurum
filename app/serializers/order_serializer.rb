class OrderSerializer < ActiveModel::Serializer
  attributes :id,
             :number,
             :status,
             :payment_status,
             :shipping_status,
             :subtotal_cents,
             :shipping_cents,
             :tax_cents,
             :discount_cents,
             :total_cents,
             :currency,
             :created_at,
             :updated_at

  belongs_to :user, serializer: UserSerializer, if: -> { object.user.present? }
  has_many :order_items, serializer: OrderItemSerializer
end
