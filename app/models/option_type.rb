class OptionType < ActiveRecord::Base
  has_many :option_values, :order => :position, :dependent => :destroy
  has_many :product_option_types, :dependent => :destroy
  validates :presentation, :presence => true
  validates :name, :presence => true
end
