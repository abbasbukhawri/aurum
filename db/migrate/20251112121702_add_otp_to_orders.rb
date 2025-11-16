class AddOtpToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :otp_code, :string
    add_column :orders, :otp_sent_at, :datetime
    add_column :orders, :otp_verified, :boolean
  end
end
