class AdminUser < ActiveRecord::Base
  has_secure_password
  has_attached_file :avatar, :styles => IMAGE_STYLES
  validates :email, :uniqueness => true, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates_attachment_presence :avatar
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']
  validates :name, :presence => true
  validates :surname, :presence => true
  validates :password, :presence =>  true,
                     :length => { :minimum => 6 },
                     :if => lambda{|admin_user| admin_user.new_record? || admin_user.password.present?}
  validate :check_password_confirmation
  
  def password_confirmation=(password_confirmation)
    write_attribute(:password_confirmation,password_confirmation)
  end
  def password_confirmation
    read_attribute(:password_confirmation)
  end
  def full_name
    self.name.to_s + self.surname.to_s
  end
  private
  def check_password_confirmation
    if self.password.present? && self.password != self.password_confirmation
      self.errors.add(:password_confirmation, "and password does not match")
    else
      return true
    end
  end
  
end
