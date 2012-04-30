class AddNameAndSurnameToAdminUser < ActiveRecord::Migration
  def change
    add_column(:admin_users, :name, :string)
    add_column(:admin_users, :surname, :string)
  end
end
