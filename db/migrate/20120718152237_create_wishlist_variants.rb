class CreateWishlistVariants < ActiveRecord::Migration
  def change
    create_table :wishlist_variants do |t|

      t.timestamps
    end
  end
end
