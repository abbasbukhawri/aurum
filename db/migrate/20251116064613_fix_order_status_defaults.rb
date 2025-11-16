class FixOrderStatusDefaults < ActiveRecord::Migration[8.0]
  def up
    # Update existing weird "0" values
    execute <<~SQL
      UPDATE orders SET status = 'pending' WHERE status = '0' OR status IS NULL;
      UPDATE orders SET payment_status = 'unpaid' WHERE payment_status = '0' OR payment_status IS NULL;
    SQL

    change_column_default :orders, :status,          from: "0", to: "pending"
    change_column_default :orders, :payment_status,  from: "0", to: "unpaid"
  end

  def down
    change_column_default :orders, :status,         from: "pending", to: "0"
    change_column_default :orders, :payment_status, from: "unpaid",  to: "0"
  end
end
