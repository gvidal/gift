class CreateAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string :email
      t.string :password_digest
      t.timestamps
    end
  end
end
