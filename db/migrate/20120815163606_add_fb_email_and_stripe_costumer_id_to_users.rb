class AddFbEmailAndStripeCostumerIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_email, :string
    add_column :users, :stripe_costumer_id, :string
  end
end
