class PaymentSummaryVariant < ActiveRecord::Base
  belongs_to :variant
  belongs_to :payment_summary
  
  validates :price, numericality:{greater_than: 0.0}
  validates :quantity, numericality: {only_integer: true, greater_than: 0}
  validates :variant_id, :payment_summary_id, :price, :quantity, presence: true
  validate :variant_can_be_bought, :if => lambda{|payment_summary_variant| !payment_summary_variant.payment_summary.confirmed}
  
  before_save :set_price
  
  private
  def variant_can_be_bought
    if self.variant.can_be_bought?(self.quantity)
      true
    else
      errors.add :quantity, "is too high"
      false
    end
  end
  def set_price
    self.price = self.variant.price
  end
end
