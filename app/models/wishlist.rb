class Wishlist < ActiveRecord::Base
  belongs_to :user_admin, class_name: :User
  has_many :user_wishlists
  has_many :users, through: :user_wishlists
  
end
