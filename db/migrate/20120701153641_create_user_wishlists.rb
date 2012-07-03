class CreateUserWishlists < ActiveRecord::Migration
  def change
    create_table :user_wishlists do |t|
      t.integer :user_id
      t.integer :wishlist_id
      t.timestamps
    end
    add_index :user_wishlists, [:user_id, :wishlist_id], unique: true
  end
end
