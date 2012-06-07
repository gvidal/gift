class ChangePriceFromIntegerToFloat < ActiveRecord::Migration
  def up
    change_column(:variants, :price, :float)
  end

  def down
    change_column(:variants, :price, :integer)
  end
end
