class AddStateToWishlist < ActiveRecord::Migration
  def change
    add_column(:wishlists,:state, :string, :default => "new")
    Wishlist.update_all(["state = ?", "new"])
  end
end
