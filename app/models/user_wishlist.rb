class UserWishlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :wishlist
  before_destroy  :destroy_wishlist_variant_votes
  
  private
  def destroy_wishlist_variant_votes
    if self.wishlist.wishlist_variant_votes.destroy_all
      true
    else
      self.errors.add_to_base("could not destroy votes")
      false
    end
  end
end
