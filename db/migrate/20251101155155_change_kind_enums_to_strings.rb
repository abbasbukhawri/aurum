class ChangeKindEnumsToStrings < ActiveRecord::Migration[8.0]
  def change
    change_column :gemstones, :kind, :string
  end
end
