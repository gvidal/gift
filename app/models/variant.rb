class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :wishlist_variant_votes, dependent: :destroy
  has_many :wishlist, through: :wishlist_variants
  
  validates :sku, presence: true, uniqueness: {scope: [:product_id, :is_master]}
  validates :price, presence: true, numericality: {greater_than: 0.0}
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  scope :is_master, lambda{|value| where(:is_master => value)}
  scope :active, lambda{|value = true|
      quantity = self.arel_table[:quantity]
      self.where(quantity.gt(0)).joins(:product).merge(Product.are_active)
  }
  
  scope :ids_in, lambda{|values| where(:id => values)}
  media_attachment :variant_images,:image, required: true
  
  def first_image
    self.variant_images.first.asset
  end
  
  def active?
    self.quantity > 0 && self.product.is_active?
  end
  
  def voted_ok?(wishlist)
    self.wishlist_variant_votes.find_by_wishlist_id_and_vote(wishlist.id, true)
  end
  
  def voted_ko?(wishlist)
    self.wishlist_variant_votes.find_by_wishlist_id_and_vote(wishlist.id, false)
  end
  
  def num_votes(wishlist, true_or_false)
    self.wishlist_variant_votes.where(wishlist_id: wishlist.id, vote: true_or_false).count
  end
  
  def can_be_bought? number_of_units
    self.active? && ((self.quantity - number_of_units) >= 0)
  end
  
  def buy number_of_units
    if can_be_bought? number_of_units
      self.quantity -= number_of_units
      self.save
    else
      false
    end
  end
  
end
