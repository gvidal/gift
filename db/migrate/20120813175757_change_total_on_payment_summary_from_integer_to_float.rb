class ChangeTotalOnPaymentSummaryFromIntegerToFloat < ActiveRecord::Migration
  def up
    change_column(:payment_summaries, :total, :float)
  end

  def down
    change_column(:payment_summaries, :total, :integer)
  end
end
