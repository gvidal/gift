class CreateWishlistVariantVotes < ActiveRecord::Migration
  def change
    create_table :wishlist_variant_votes do |t|
      t.integer :wishlist_id
      t.integer :variant_id
      t.boolean :vote #vote is true (agree) or false (disagree)
      t.timestamps
    end
    add_index :wishlist_variant_votes, [:wishlist_id, :variant_id], unique: true
  end
end
