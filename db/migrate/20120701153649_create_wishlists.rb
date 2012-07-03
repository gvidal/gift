class CreateWishlists < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
      t.integer   :user_admin_id
      t.string    :name
      t.text      :description
      t.timestamps
    end
  end
end
