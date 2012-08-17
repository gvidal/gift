class AddEmailToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :email, :string
    change_column :payment_summaries, :total, :decimal,:precision => 8, :scale => 2
  end
end
