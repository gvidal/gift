class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_one :fb_authentication, conditions: "authentications.provider = 'facebook'", class_name: :Authentication
  datepicker_attributes :created_at
  validates :current_token, :presence => true
#  validates :authentication_ids, :presence => true, :length => { :minimum => 1 } 
   validates :authentications, :presence =>  true
#  validates :birth_date, :presence => true
  
  before_validation :set_birth_date
  
  
  has_many :user_wishlists
  has_many :wishlists, through: :user_wishlists
  
  has_many :own_wishlists, class_name: :Wishlist, foreign_key: :user_admin_id
  
  
  scope :with_facebook_uid, lambda{|values| includes(:authentications).where(["authentications.uid IN (?) AND authentications.provider = ?", values,'facebook'])}
  
  def active_wishlists
    (self.wishlists.active + 
        self.own_wishlists.active).uniq
  end
  
  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'],
                          :uid => omniauth['uid'],
                          :user => self)  
  end
  
  def set_current_token(omniauth)
    if omniauth["provider"] == "facebook"
      self.current_token = omniauth["credentials"]["token"]
    end
  end
  
  
  def set_birth_date
#    self.birth_date = Koala::Facebook::GraphAPI.new(self.current_token)
  end
  
  def graph_api
    @graph_api ||= Koala::Facebook::GraphAPI.new(self.current_token)
  end
  
  def fb_picture
    self.graph_api.get_picture(self.fb_authentication.uid)
  end
  

  
  
end
