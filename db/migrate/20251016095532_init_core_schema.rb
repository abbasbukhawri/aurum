class InitCoreSchema < ActiveRecord::Migration[8.0]
  def change
    #
    # 0) EXTENSIONS (for GIN on jsonb; usually enabled by default)
    #
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
    enable_extension "btree_gin" unless extension_enabled?("btree_gin")

    #
    # 1) USERS (Devise-compatible)
    #
    create_table :users do |t|
      # profile
      t.string  :first_name
      t.string  :last_name
      t.string  :phone
      t.integer :role, default: 0, null: false  # 0=customer, 1=admin

      # Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      # Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      t.timestamps
    end
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :role

    #
    # 2) TAXONOMY / MATERIALS
    #
    create_table :categories do |t|
      t.string  :name, null: false
      t.string  :slug
      t.integer :parent_id
      t.integer :position
      t.timestamps
    end
    add_index :categories, :slug
    add_index :categories, :parent_id
    add_index :categories, :position

    create_table :metals do |t|
      t.string  :name, null: false
      t.integer :purity_karat  # 24/22/18 for gold, nil/0 for silver/alloy
      t.timestamps
    end
    add_index :metals, :name

    create_table :gemstones do |t|
      t.string  :name, null: false
      t.integer :kind, default: 0, null: false  # 0=natural,1=lab_created,2=artificial
      t.string  :color
      t.timestamps
    end
    add_index :gemstones, :name
    add_index :gemstones, :kind

    #
    # 3) CATALOG (products, variants, product_gemstones)
    #
    create_table :products do |t|
      t.string  :name, null: false
      t.string  :slug
      t.string  :sku
      t.references :category, foreign_key: true
      t.references :metal,    foreign_key: true
      t.text    :description
      t.decimal :weight_grams, precision: 10, scale: 3
      t.integer :base_price_cents
      t.string  :currency
      t.boolean :visible, default: true, null: false
      t.timestamps
    end
    add_index :products, :slug
    add_index :products, :sku
    add_index :products, :currency
    add_index :products, :visible


    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.jsonb  :option_values, null: false, default: {}   # size, length, finish, etc.
      t.integer :price_cents
      t.integer :stock,  default: 0,  null: false
      t.string  :sku
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :variants, :sku, unique: true
    add_index :variants, :option_values, using: :gin

    create_table :product_gemstones do |t|
      t.references :product,  null: false, foreign_key: true
      t.references :gemstone, null: false, foreign_key: true
      t.decimal :carat_weight, precision: 10, scale: 3
      t.timestamps
    end

    #
    # 4) CARTS & CART ITEMS
    #
    create_table :carts do |t|
      t.references :user, foreign_key: true
      t.integer :status, default: 0, null: false  # 0=active,1=converted,2=abandoned
      t.timestamps
    end
    add_index :carts, :status

    create_table :cart_items do |t|
      t.references :cart,    null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.integer    :quantity, null: false, default: 1
      t.timestamps
    end

    #
    # 5) ADDRESSES
    #
    create_table :addresses do |t|
      t.references :user, foreign_key: true
      t.integer :kind, default: 0, null: false   # 0=billing,1=shipping (or vice versa)
      t.string :full_name
      t.string :phone
      t.string :line1
      t.string :line2
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country
      t.timestamps
    end
    add_index :addresses, :kind

    #
    # 6) ORDERS & ORDER ITEMS
    #
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :cart, foreign_key: true
      t.string  :number
      t.integer :status,          default: 0, null: false  # 0=draft,1=placed,2=paid,3=shipped,4=completed,5=canceled
      t.integer :payment_status,  default: 0, null: false  # 0=pending,1=authorized,2=captured,3=failed,4=refunded
      t.integer :shipping_status, default: 0, null: false  # 0=not_required,1=pending,2=in_transit,3=delivered

      t.integer :subtotal_cents, default: 0, null: false
      t.integer :shipping_cents, default: 0, null: false
      t.integer :tax_cents,      default: 0, null: false
      t.integer :discount_cents, default: 0, null: false
      t.integer :total_cents,    default: 0, null: false
      t.string  :currency

      t.references :billing_address,  null: true
      t.references :shipping_address, null: true

      t.timestamps
    end
    add_index :orders, :number, unique: true
    add_foreign_key :orders, :addresses, column: :billing_address_id
    add_foreign_key :orders, :addresses, column: :shipping_address_id

    create_table :order_items do |t|
      t.references :order,   null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.string  :name
      t.string  :sku
      t.integer :quantity,    null: false, default: 1
      t.integer :price_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.timestamps
    end

    #
    # 7) COUPONS
    #
    create_table :coupons do |t|
      t.string  :code, null: false
      t.integer :discount_type, null: false, default: 0  # 0=amount,1=percent
      t.integer :discount_value, null: false, default: 0
      t.boolean :active, default: true, null: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.timestamps
    end
    add_index :coupons, :code, unique: true
    add_index :coupons, :active

    #
    # 8) PRODUCT ATTRIBUTES (safe names, avoiding "Attribute" collision)
    #
    create_table :spec_options do |t|
      t.string  :name, null: false             # e.g., "Finish", "Chain Length"
      t.integer :kind, null: false, default: 0 # 0=select,1=multi,2=range
      t.timestamps
    end
    add_index :spec_options, :name

    create_table :product_spec_values do |t|
      t.references :product,     null: false, foreign_key: true
      t.references :spec_option, null: false, foreign_key: true
      t.string  :value, null: false          # e.g., "Matte", "18 in"
      t.timestamps
    end

    #
    # 9) ACTIVE STORAGE (inline so we keep one migration file)
    #
    create_table :active_storage_blobs, id: :bigserial, force: :cascade do |t|
      t.string   :key,          null: false
      t.string   :filename,     null: false
      t.string   :content_type
      t.text     :metadata
      t.bigint   :byte_size,    null: false
      t.string   :checksum
      t.datetime :created_at,   null: false
      t.string   :service_name, null: false
    end
    add_index :active_storage_blobs, :key, unique: true

    create_table :active_storage_attachments, id: :bigserial, force: :cascade do |t|
      t.string     :name,     null: false
      t.references :record,   null: false, polymorphic: true, index: false
      t.references :blob,     null: false
      t.datetime   :created_at, null: false
    end
    add_index :active_storage_attachments, [:record_type, :record_id, :name, :blob_id], name: :index_active_storage_attachments_uniqueness, unique: true
    add_foreign_key :active_storage_attachments, :active_storage_blobs, column: :blob_id

    create_table :active_storage_variant_records, id: :bigserial, force: :cascade do |t|
      t.belongs_to :blob, null: false, index: false
      t.string :variation_digest, null: false
    end
    add_index :active_storage_variant_records, [:blob_id, :variation_digest], name: :index_active_storage_variant_records_uniqueness, unique: true
    add_foreign_key :active_storage_variant_records, :active_storage_blobs, column: :blob_id
  end
end
