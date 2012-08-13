class ChangePaymentsStructure < ActiveRecord::Migration
  def up
    remove_column :payments,:price_to_pay
  end

  def down
    add_column :payments,:price_to_pay, :float
  end
end
