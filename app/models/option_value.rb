class OptionValue < ActiveRecord::Base
  belongs_to :option_type
  before_create :set_order
  acts_as_list scope: :option_type
  attr_reader :option_type_token
  
  validates :name, :display,:option_type_id, presence: true
  
  scope :with_product_id, lambda{|value|
    joins(option_type: :products).where(products: {id: value})
  }
  search_methods :with_product_id
#  validates_existence_of :category 
  def option_type_token=(value)
    self.option_type_id = value.to_i
  end
  
  def with_option_string
    
  end
  
  private
  def set_order
    self.position = self.class.where(option_type_id: self.option_type_id).order("position DESC").first.try(:position) || 0
  end
end
