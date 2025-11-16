class CreateWishlistItems < ActiveRecord::Migration[8.0]
  def change
    create_table :wishlist_items do |t|
      t.bigint :wishlist_id, null: false
      t.bigint :variant_id,  null: false

      t.timestamps
    end

    add_index :wishlist_items, :wishlist_id
    add_index :wishlist_items, :variant_id
    add_index :wishlist_items, [:wishlist_id, :variant_id], unique: true
  end
end
