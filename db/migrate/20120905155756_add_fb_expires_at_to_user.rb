class AddFbExpiresAtToUser < ActiveRecord::Migration
  def change
    add_column(:users, :fb_expires_at, :datetime)
  end
end
