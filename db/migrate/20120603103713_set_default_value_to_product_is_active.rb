class SetDefaultValueToProductIsActive < ActiveRecord::Migration
  def up
    change_column_default(:products, :is_active, false)
  end

  def down
  end
end
