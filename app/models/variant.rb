class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :wishlist_variant_votes, dependent: :destroy
  has_many :wishlist, through: :wishlist_variants
  validates :sku, :presence => true, :uniqueness => {:scope => [:product_id, :is_master]}
  validates :price, :presence => true, :numericality => {:greater_than => 0.0}
  scope :is_master, lambda{|value| where(:is_master => value)}
  scope :active, lambda{|value = true| where(:is_active => value)}
  media_attachment :variant_images,:image, required: true
  
  def first_image
    self.variant_images.first.asset
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
end
