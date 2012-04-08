class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :current_token
      t.date :birth_date
      t.timestamps
    end
  end
end
