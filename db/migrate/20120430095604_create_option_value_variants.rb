class CreateOptionValueVariants < ActiveRecord::Migration
  def change
    create_table :option_value_variants do |t|
      t.integer :option_value_id
      t.integer :variant_id
      t.timestamps
    end
    add_index :option_value_variants, [:option_value_id, :variant_id], :unique => true
  end
end
