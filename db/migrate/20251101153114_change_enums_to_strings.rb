class ChangeEnumsToStrings < ActiveRecord::Migration[8.0]
  def change
    change_column :orders, :status, :string
    change_column :orders, :payment_status, :string
    change_column :orders, :shipping_status, :string

    change_column :users, :role, :string

    change_column :carts, :status, :string

  end
end
