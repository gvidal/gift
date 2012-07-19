class UserWishlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :wishlist
end
