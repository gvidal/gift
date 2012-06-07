class Variant < ActiveRecord::Base
  belongs_to :product
  validates :sku, :presence => true, :uniqueness => {:scope => [:product_id, :is_master]}
  validates :price, :presence => true, :numericality => {:greater_than => 0.0}
  scope :is_master, lambda{|value| where(:is_master => value)}
  scope :active, lambda{|value| where(:is_active => value)}
  
  
end
