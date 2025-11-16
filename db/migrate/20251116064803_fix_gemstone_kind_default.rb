class FixGemstoneKindDefault < ActiveRecord::Migration[8.0]
  def up
    # Treat old "0" as "natural"
    execute <<~SQL
      UPDATE gemstones SET kind = 'natural' WHERE kind = '0' OR kind IS NULL;
    SQL

    change_column_default :gemstones, :kind, from: "0", to: "natural"
  end

  def down
    change_column_default :gemstones, :kind, from: "natural", to: "0"
  end
end
