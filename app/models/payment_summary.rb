class PaymentSummary < ActiveRecord::Base
  belongs_to :wishlist
  has_many :payment_summary_variants, dependent: :destroy
  has_many :variants, through: :payment_summary_variants
  has_many :payments, dependent: :destroy
  
  validates  :price_to_pay, numericality: {only_integer: false, greater_than: 0.0}
  validates  :wishlist_id, :price_to_pay, presence: true
  validate    :wishlist_summary_variants_have_same_price, on: :update
  
  after_save :create_payments, :if => lambda{|payment_summary| payment_summary.confirmed_change == [false, true]}
  after_save :set_wishlist_state_to_paying, :if => lambda{|payment_summary| payment_summary.confirmed_change == [false, true]}
  
  def confirm
    self.confirmed = true
    self.save
  end
  
  private
  def wishlist_summary_variants_have_same_price
    if !self.confirmed && self.payment_summary_variants.any?{|x| x.variant.price != x.price}
      self.errors.add(:payment_summary_variants, "price has changed")
      false
    else
      true
    end
  end
  
  def create_payments
    self.wishlist.all_participants.each do |user|
      payment = self.payments.new(state: "to_pay", user: user)
      payment.save!
    end
  end
  
  def set_wishlist_state_to_paying
    wishlist_aux = self.wishlist
    wishlist_aux.state = "paying"
    wishlist_aux.save!
  end
end
