class Authentication < ActiveRecord::Base
  belongs_to :user
  
#  validates :user_id , :presence => true
  validates :user, :presence =>  true
  validates :provider, :inclusion => {:in => %w(facebook)}
  validates :uid, :presence => true
  
end
