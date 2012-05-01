class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  datepicker_attributes :created_at
  validates :current_token, :presence => true
#  validates :authentication_ids, :presence => true, :length => { :minimum => 1 } 
   validates :authentications, :presence =>  true
#  validates :birth_date, :presence => true
  
  before_validation :set_birth_date
  
  
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
  
end
