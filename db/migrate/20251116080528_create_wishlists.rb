class CreateWishlists < ActiveRecord::Migration[8.0]
  def change
    create_table :wishlists do |t|
      t.bigint :user_id
      t.string :session_token          # for guest users
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :wishlists, :user_id
    add_index :wishlists, :session_token
  end
end
