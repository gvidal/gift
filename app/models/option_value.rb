class OptionValue < ActiveRecord::Base
  belongs_to :option_type
  before_save :set_order
  acts_as_list :scope => :option_type
  attr_reader :option_type_token
  def option_type_token=(value)
    self.option_type_id = value.to_i
  end
end
