class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment_summary
  validates :state, inclusion: {in: %w(to_pay payed)}
  validates :email, :presence => true, 
                    :if => lambda{|payment| payment.state_change == ['to_pay',"payed"]}, 
                   :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
                                  
  after_save :update_wishlist_status, :if => lambda{|payment| payment.state_change == ['to_pay',"payed"]}
  
  attr_accessor :stripe_card_token
  
  scope :state, lambda { |value| 
    where({:state => value})
  }
  scope :states, lambda{|*values|
    state_aux = Payment.arel_table[:state]
    state_conditions = nil
    if value = values.slice!(0)
      states_conditions = state_aux.eq(value) 
    end
    values.each do |value|
      state_conditions = states_conditions.or(state_aux.eq(value))
    end
    where(state_conditions)
  }
  scope :with_user, lambda { |value|
    user_id = (value.is_a?(User) ? value.id : value)
    where({user_id: user_id})
  }
  scope :exclude_id, lambda{|value|
    where(Payment.arel_table[:id].not_eq(value))
  }
  
  scope :payment_summary, lambda{|value|
    aux = value.is_a?(PaymentSummary) ? value.id : value
    where({payment_summary_id: aux})
  }
  
  def save_with_payment(attributes)
    self.assign_attributes(attributes)
    self.state = "payed"
    if valid?
      charge = Stripe::Charge.create(
        :amount => (self.payment_summary.price_to_pay.to_f * 100).to_i, # amount in cents
        :currency => "usd",
        :card => stripe_card_token,
        :description => "this is to buy the following items on this shop"
      )
      require 'ruby-debug';debugger;1
      save!  
    end  
  rescue Stripe::InvalidRequestError => e  
    logger.error "Stripe error while creating customer: #{e.message}"  
    errors.add :base, "There was a problem with your credit card."  
  end
  private
  def update_wishlist_status
    payed = self.class.payment_summary(self.payment_summary_id).exclude_id(self.id)
    total = self.class.payment_summary(self.payment_summary_id).exclude_id(self.id).state("payed")
    if payed.count == total.count
      require 'ruby-debug';debugger;1
      wishlist = self.payment_summary.wishlist
      wishlist.state("payed")
      wishlist.save!
    else
      true
    end
  end
end
