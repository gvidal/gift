class CreatePaymentSummaryVariants < ActiveRecord::Migration
  def change
    create_table :payment_summary_variants do |t|
      t.integer :variant_id
      t.integer :payment_summary_id
      t.float   :price 
      t.integer :quantity
      t.timestamps
    end
  end
end
