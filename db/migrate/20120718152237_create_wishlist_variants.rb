class CreateWishlistVariants < ActiveRecord::Migration
  def change
    create_table :wishlist_variants do |t|
      t.integer :wishlist_id
      t.integer :variant_id
      t.timestamps
    end
    add_index(:wishlist_variants, [:wishlist_id, :variant_id], :unique => true)
  end
end
