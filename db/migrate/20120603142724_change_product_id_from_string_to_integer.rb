class ChangeProductIdFromStringToInteger < ActiveRecord::Migration
  def up
    change_column(:variants, :product_id, :integer)
  end

  def down
    change_column(:variants, :product_id, :string)
  end
end
