class AddQuantityToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :quantity, :integer
  end
end
