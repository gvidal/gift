class AddIndexToWishlists < ActiveRecord::Migration
  def change
    add_index :wishlists, :user_admin_id
  end
end
