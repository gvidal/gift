class AddFacebookTokenExpiresAt < ActiveRecord::Migration
  def up
    add_column :authentications, :facebook_token_expires_at, :integer
  end

  def down
  end
end
