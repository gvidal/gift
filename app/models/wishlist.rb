class Wishlist < ActiveRecord::Base
  belongs_to :user_admin, class_name: :User
  has_many :user_wishlists
  has_many :users, through: :user_wishlists
  belongs_to :gift_receiver_facebook, class_name: "Authentication", foreign_key: :uid, conditions: {provider: "facebook"}
  
  scope :active, lambda{|value = true| where(active: value)}
  
  validates :gift_receiver_facebook_id, presence: true
  before_save  :gift_receiver_facebook_is_friend
  validate  :name, presence: true, uniqueness: {scope: :user_admin_id}
  
  accepts_nested_attributes_for :users, allow_destroy: true
  
  def is_admin?(current_user)
    self.user_admin_id == current_user.id
  end
  
  private
  def gift_receiver_facebook_is_friend
    fb_uids = self.user_admin.graph_api.get_connections("me", "friends").map{|x| x["id"]}
    u = User.where(["users.id IN (?)", self.user_ids]).joins(:authentications)
    self.users = u.where(["authentications.uid IN (?) AND authentications.provider = ?",fb_uids, "facebook"])
  end
  
end
