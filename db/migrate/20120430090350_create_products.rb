class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.text    :description
      t.string  :permalink
      t.datetime  :avaible_on
      t.boolean :is_active, :null => false
      t.datetime  :expires_on
      t.timestamps
    end
  end
end
