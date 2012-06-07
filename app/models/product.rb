class Product < ActiveRecord::Base
  has_many :product_option_types, :dependent => :destroy
  has_many :option_types, :through => :product_option_types
  has_one :master,
      :class_name => 'Variant',
      :conditions => {:is_master => true}
#  validates :is_active, presence: true
  has_many :variants, :conditions => {:is_master => false}
  has_many :variants_with_master, :class_name => "Variant", :dependent => :destroy

#  validates :permalink, :uniqueness => true, :presence => true
  validates :name, :presence => true, :uniqueness => true
  
  datepicker_attributes :avaible_on, :expires_on
  
  before_save :set_permalink
  after_create  :set_master
  after_initialize :initialize_master, :if => lambda{|product| product.new_record? && !product.master}
  
#  accepts_nested_attributes_for :variants, :reject_if => lambda { |a| a[:sku].blank? || a[:price].blank?}, :allow_destroy => true
  accepts_nested_attributes_for :master
  
  attr_reader :option_types_tokens
  
  def self.are_active(value = true)
    table_name = self.quoted_table_name
    if value
     a =  self.where(["#{table_name}.avaible_on >= ? OR #{table_name}.avaible_on IS NULL",Time.zone.now.to_s(:default)])
     a = a.where(["#{table_name}.expires_on <= ? OR #{table_name}.expires_on IS NULL", Time.zone.now.to_s(:default)])
     a = a.where(:is_active => true)
     a
    else
     time = Time.zone.now.to_s(:default)
     self.where(["#{table_name}.avaible_on < ? OR #{table_name}.expires_on > ? OR #{table_name}.is_active = ?",
                 time, time, false])
    end
  end
  
  
  def option_types_tokens=(values)
    self.option_type_ids = self.class.ids_from_tokens(values)
  end

  
  private
  def set_permalink
    perm = self.name.parameterize
    num = 1
    aux_perm = perm.dup
    while((self.new_record? ? Product.search.permalink_eq(perm) : Product.search(permalink_eq: perm, id_ne: self.id)).first)
      aux_perm = perm + "#{num}"
      num += 1
    end
    self.permalink = aux_perm
  end
  def set_master
    self.master.is_master = true
  end
  def initialize_master
    self.build_master
  end
end
