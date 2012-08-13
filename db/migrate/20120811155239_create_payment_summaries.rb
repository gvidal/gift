class CreatePaymentSummaries < ActiveRecord::Migration
  def change
    create_table :payment_summaries do |t|
      t.float :price_to_pay
      t.integer :wishlist_id
      t.boolean :confirmed, :default => false
      t.timestamps
    end
    add_column :payments, :payment_summary_id, :integer
  end
end
