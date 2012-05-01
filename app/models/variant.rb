class Variant < ActiveRecord::Base
  belongs_to :product
  scope :is_master, lambda{|value| where(:is_master => value)}
  scope :active, lambda{|value| where(:is_active => value)}
end
