class AddGiftReceiverGiftUuidAndFriendReceiverGiftServiceToWishlist < ActiveRecord::Migration
  def change
    add_column(:wishlists, :gift_receiver_facebook_id, :string)
  end
end
