class Payment < ActiveRecord::Base
  belongs_to :user
  validates :state, inclusion: {in: %w(to_pay payed)}
  
  attr_accessor :stripe_card_token
  
  scope :state, lambda{|value| {:state => value}}
end
