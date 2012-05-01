class Product < ActiveRecord::Base
  has_many :product_option_types, :dependent => :destroy
  has_many :option_types, :through => :product_option_types
  has_one :master,
      :class_name => 'Variant',
      :conditions => {:is_master => true}
  has_many :variants, :conditions => {:is_master => false}
  has_many :variants_with_master, :class_name => "Variant", :dependent => :destroy

  validates :permalink, :uniqueness => true, :presence => true
  validates :name, :presence => true, :uniqueness => true
  
  datepicker_attributes :avaible_on, :expires_on
  before_save :set_permalink
  
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
  
  private
  def set_permalink
    perm = self.name.try(:parameterize) || ""
    num = 1
    aux_perm = perm.dup
    while(Product.find_by_permalink(perm))
      aux_perm = perm + "#{num}"
      num += 1
    end
    self.permalink = aux_perm
  end
end
