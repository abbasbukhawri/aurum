class RemoveShippingStatusFromOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :shipping_status, :string
  end
end
