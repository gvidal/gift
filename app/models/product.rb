class Product < ActiveRecord::Base
  has_many :product_option_types, :dependent => :destroy
  has_many :option_types, :through => :product_option_types
  has_one :master,
      :class_name => 'Variant',
      :conditions => {:is_master => true}
#  validates :is_active, presence: true
  has_many :variants, :conditions => {:is_master => false}
  has_many :variants_with_master, :class_name => "Variant", :dependent => :destroy
  
  
  has_many :related_products_association, :dependent => :destroy, :class_name => :RelatedProduct
  has_many :related_products, :dependent => :destroy, :through => :related_products_association, :source => :related_product
  
  has_many :inverse_of_related_products_association, :dependent => :destroy, :class_name => :RelatedProduct, :foreign_key => :related_product_id
  has_many :inverse_of_related_products, :through => :inverse_of_related_products_association, :class_name => :Product, :source => :product
#  validates :permalink, :uniqueness => true, :presence => true
  validates :name, :presence => true, :uniqueness => true
  
  datepicker_attributes :avaible_on, :expires_on
  
  before_save :set_permalink
  after_create  :set_master
  after_initialize :initialize_master, :if => lambda{|product| product.new_record? && !product.master}
  
#  accepts_nested_attributes_for :variants, :reject_if => lambda { |a| a[:sku].blank? || a[:price].blank?}, :allow_destroy => true
  accepts_nested_attributes_for :master
  
  
  
  attr_reader :option_types_tokens, :related_products_tokens, :inverse_of_related_products_tokens
  
  def is_active?
    (self.avaible_on.blank? || self.avaible_on >= Time.zone.now) && (self.expires_on.blank? || self.expires_on <= Time.zone.now) && self.is_active
  end
  
  def self.are_active(value = true)
    arel_avaible_on = self.arel_table[:avaible_on]
    arel_expires_on = self.arel_table[:expires_on]
    arel_is_active = self.arel_table[:is_active]
    time = Time.zone.now.to_s(:default)
    if value
     products = self.where(:is_active => true)
     products = products.where(arel_avaible_on.lteq(time).or(arel_avaible_on.eq(nil)))
     products = products.where(arel_expires_on.lteq(time).or(arel_expires_on.eq(nil)))
     products
    else
     self.where(arel_avaible_on.lt(time).or(arel_expires_on.gt(time)).or(arel_is_active).eq(false))
    end
  end
  
  def active_total_related_products
    related_products_arel = RelatedProduct.arel_table
    products = self.class.includes([:inverse_of_related_products_association,:related_products_association])
    products = products.where(related_products_arel[:related_product_id].eq(self.id).or(related_products_arel[:product_id].eq(self.id)))
    products.are_active.uniq(true)
  end
  
  
  def option_types_tokens=(values)
    self.option_type_ids = self.class.ids_from_tokens(values)
  end
  
  def related_products_tokens=(values)
    self.related_product_ids = self.class.ids_from_tokens(values)
  end
  
  def inverse_of_related_products_tokens=(values)
    self.inverse_of_related_product_ids = self.class.ids_from_tokens(values)
  end
  
  def to_param
    self.permalink
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
