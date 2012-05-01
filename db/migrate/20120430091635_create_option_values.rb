class CreateOptionValues < ActiveRecord::Migration
  def change
    create_table :option_values do |t|
      t.string  :name
      t.string  :display
      t.integer :option_type_id, :null =>  false
      t.timestamps
    end
  end
end
