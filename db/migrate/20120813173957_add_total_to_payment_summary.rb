class AddTotalToPaymentSummary < ActiveRecord::Migration
  def change
    add_column(:payment_summaries, :total, :integer)
  end
end
