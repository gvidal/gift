class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :wishlist_id, :null => false
      t.string  :state
      t.string  :stripe_customer_token
      t.timestamps
    end
  end
end
