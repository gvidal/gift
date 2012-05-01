class CreateProductOptionTypes < ActiveRecord::Migration
  def change
    create_table :product_option_types do |t|
      t.integer :option_type_id, :null => false
      t.integer :product_id, :null => false
      t.timestamps
    end
    add_index :product_option_types, [:option_type_id, :product_id], :unique => true
  end
end
