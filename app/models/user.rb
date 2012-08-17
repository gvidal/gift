class User < ActiveRecord::Base
  datepicker_attributes :created_at
  validates :current_token, :presence => true
#  validates :authentication_ids, :presence => true, :length => { :minimum => 1 } 
   validates :authentications, :presence =>  true
#  validates :birth_date, :presence => true
  
  before_validation :set_birth_date
  before_create :set_facebook_email
  
  scope :id_eq, lambda{|value|
    where(id: value)
  }
  
  
  has_many :user_wishlists
  has_many :wishlists, through: :user_wishlists
  
  has_many :own_wishlists, class_name: :Wishlist, foreign_key: :user_admin_id
  
  has_many  :active_payments, class_name: :Payment, conditions: {state: 'to_pay'}
  has_many  :authentications, :dependent => :destroy
  has_one   :fb_authentication, conditions: "authentications.provider = 'facebook'", class_name: :Authentication
  has_many  :wishlist_variant_votes, dependent: :destroy
  has_many :payments
  
  
  scope :with_facebook_uid, lambda { |values| 
    includes(:authentications).where(authentications: {uid: values, provider: 'facebook'})
  }
  
  def active_wishlists
    Wishlist.with_user(self).active
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
    @graph_api ||= Koala::Facebook::API.new(self.current_token)
  end
  
  def fb_picture
    self.graph_api.get_picture(self.fb_authentication.uid)
  end
  
  def token_expired?(new_time = nil)
    expiry = (new_time.nil? ? token_expires_at : Time.at(new_time))
    return true if expiry < Time.now ## expired token, so we should quickly return
    token_expires_at = expiry
    save if changed?
    false # token not expired. :D
  end
  
  private
  def set_facebook_email
    self.facebook_email = self.graph_api.get_object("me")["email"]
  end
end
