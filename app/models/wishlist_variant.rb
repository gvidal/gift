class WishlistVariant < ActiveRecord::Base
  belongs_to :variant
  belongs_to :wishlist
end
