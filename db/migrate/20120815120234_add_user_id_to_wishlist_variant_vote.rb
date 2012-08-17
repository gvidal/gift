class AddUserIdToWishlistVariantVote < ActiveRecord::Migration
  def change
    add_column :wishlist_variant_votes, :user_id, :integer
  end
end
