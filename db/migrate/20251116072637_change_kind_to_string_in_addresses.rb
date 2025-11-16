class ChangeKindToStringInAddresses < ActiveRecord::Migration[8.0]
    def up
      # 1) Add new string column
      add_column :addresses, :kind_tmp, :string

      # 2) Map old integer kinds to string
      execute <<~SQL
        UPDATE addresses
        SET kind_tmp =
          CASE kind
            WHEN 0 THEN 'billing'
            WHEN 1 THEN 'shipping'
            ELSE 'other'
          END;
      SQL

      # 3) Drop old column and rename
      remove_column :addresses, :kind
      rename_column :addresses, :kind_tmp, :kind

      # 4) Set default
      change_column_default :addresses, :kind, from: nil, to: "billing"
    end

    def down
      # Reverse: string -> integer (if ever needed)
      add_column :addresses, :kind_tmp, :integer, default: 0, null: false

      execute <<~SQL
        UPDATE addresses
        SET kind_tmp =
          CASE kind
            WHEN 'billing'  THEN 0
            WHEN 'shipping' THEN 1
            ELSE 2
          END;
      SQL

      remove_column :addresses, :kind
      rename_column :addresses, :kind_tmp, :kind
      change_column_default :addresses, :kind, from: 0, to: 0
    end
end
