class WishlistVariantVote < ActiveRecord::Base
  belongs_to :variant
  belongs_to :wishlist
  
end
