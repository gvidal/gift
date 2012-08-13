class ChangeQuantityToPriceToPayOnPaymentsAndRemoveWishlistId < ActiveRecord::Migration
  def up
    rename_column :payments, :quantity, :price_to_pay
    remove_column :payments, :wishlist_id
  end

  def down
    rename_column :payments, :price_to_pay, :quantity
    add_column :payments, :wishlist_id, :integer
  end
end
