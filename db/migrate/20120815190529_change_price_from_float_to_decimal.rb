class ChangePriceFromFloatToDecimal < ActiveRecord::Migration
  def up
    change_column :variants, :price, :decimal,:precision => 8, :scale => 2
    change_column :payment_summaries, :price_to_pay, :decimal,:precision => 8, :scale => 2
  end

  def down
    change_column :variants, :price, :float
    change_column :payment_summaries, :price_to_pay, :float
  end
end
