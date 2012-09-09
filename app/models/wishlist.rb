class Wishlist < ActiveRecord::Base
  belongs_to :user_admin, class_name: :User
  
  has_many :user_wishlists
  has_many :users, through: :user_wishlists
  belongs_to :gift_receiver_facebook, class_name: "Authentication", 
                                      foreign_key: :uid, conditions: {provider: "facebook"}
  
  has_one :payment_summary, dependent: :destroy
  has_one :payment_summary_to_confirm,  class_name: "PaymentSummary", 
                                        conditions: {confirmed: false}
  has_one :confirmed_payment_summary,  class_name: "PaymentSummary", 
                                        conditions: {confirmed: true}                                    
  
  has_many :wishlist_variants, dependent: :destroy
  has_many :variants, through: :wishlist_variants
  
  has_many :wishlist_variant_votes, dependent: :destroy
  
  scope :active, lambda{|value = true| where(active: value)}
  scope :state, lambda{|value| where(state: value)}
  scope :with_user, lambda{|user| 
    wishlist_aux = Wishlist.arel_table
    user_wishlist_aux = UserWishlist.arel_table
    user_id = (user.is_a?(User) ? user.id : user)
    where(wishlist_aux[:user_admin_id].eq(user_id).or(user_wishlist_aux[:user_id].eq(user_id))).includes(:user_wishlists)  
  }
  scope :states, lambda{|*values|
    state_aux = Wishlist.arel_table[:state]
    state_conditions = nil
    if value = values.slice!(0)
      states_conditions = state_aux.eq(value) 
    end
    values.each do |value|
      state_conditions = states_conditions.or(state_aux.eq(value))
    end
    where(state_conditions)
  }
  scope :user_admin, lambda{|value|
    value = value.id if value.is_a?(User)
    where(user_admin_id: value)
  }
  scope :id_eq, lambda{|value| where(:id => value)}
  
  validates :gift_receiver_facebook_id, presence: true
  validates :state, inclusion: {in: %w(new paying payed)}
  before_save   :users_are_friends
  before_save   :set_active_to_false, :if => lambda{|wishlist| wishlist.state_change == ["paying", "payed"] }
  validate  :name, presence: true, uniqueness: {scope: :user_admin_id}
  
  accepts_nested_attributes_for :users, allow_destroy: true
  
  def is_admin?(current_user)
    self.user_admin_id == current_user.id
  end
  
  def all_participants
    (self.users.to_a.push(self.user_admin)).uniq
  end
  
  def create_payment_summary!(users, variant_ids_with_quantity)
    payment_summary_aux = PaymentSummary.new
    Variant.transaction do
      variants = Variant.ids_in(variant_ids_with_quantity.map{|x|x[:variant_id]}).to_a
      variants_ids = variants.map(&:id)
      variants_with_quantity = variant_ids_with_quantity.dup
      variants_with_quantity.map! do |v| 
        v[:variant_id] = v[:variant_id].to_i
        v[:quantity] = v[:quantity].to_i
        v
      end
      variants_with_quantity.select! do |v| 
        variants_ids.include?(v[:variant_id])
      end
      variants_with_quantity.map! do |x|
        x[:variant] = variants.select{|v| v.id == x[:variant_id]}.first
        x
      end
      if variants.any?{|variant| !variant.active?} || variants_with_quantity.any?{|x| !x[:variant].can_be_bought?(x[:quantity])}
        raise ActiveRecord::RollBack 
      end
      price_to_pay = price_per_user users, variants_with_quantity
      total = variants_with_quantity.inject(0) do |total, element|
        total += element[:quantity].to_i * element[:variant].price
      end
      PaymentSummary.transaction do
        raise ActiveRecord::RollBack if self.payment_summary && !self.payment_summary.destroy
        payment_summary_aux = PaymentSummary.create!(price_to_pay: price_to_pay, confirmed: false, wishlist: self, total: total)
        PaymentSummaryVariant.transaction do
          variants_with_quantity.each do |parameters|
            variant = parameters[:variant]
            quantity = parameters[:quantity]
            payment_summary_aux.payment_summary_variants.create!(variant: variant, 
                                                             price: variant.price, 
                                                             quantity: quantity)
          end
        end
      end
    end
    payment_summary_aux
  rescue Exception => e
    nil
  end
  
  def get_payment(user)
    self.payment_summary.payments.with_user(user).first
  end
  
  private
  def users_are_friends
    fb_uids = self.user_admin.graph_api.get_connections("me", "friends").map{|x| x["id"]}
    u = User.where(["users.id IN (?)", self.user_ids]).joins(:authentications)
    self.users = u.where(:authentications => {uid: fb_uids, provider: "facebook"}).to_a
  end
  
  def price_per_user(users, variants_with_quantity)
    num_users = users.count
    total = variants_with_quantity.inject(0.0) do |result,element|
      variant = element[:variant]
      quantity = element[:quantity]
      result + (variant.price * quantity.to_i.to_f)
    end
    total/num_users
  end
  def set_active_to_false
    self.active = false
    true
  end
  
end
