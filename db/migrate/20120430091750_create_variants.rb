class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :sku, :null => false
      t.string :product_id, :null => false
      t.integer :avaible, :default => 0, :null => false
      t.boolean :is_master, :null => false
      t.timestamps
    end
    add_index :variants, :product_id
  end
end
