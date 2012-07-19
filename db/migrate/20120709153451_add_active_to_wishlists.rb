class AddActiveToWishlists < ActiveRecord::Migration
  def change
    add_column(:wishlists, :active, :boolean, default: true, null: false)
  end
end
