class RemoveAvaibleFromVariants < ActiveRecord::Migration
  def up
    remove_column(:variants, :avaible)
  end

  def down
    add_column(:variants, :avaible, :integer)
  end
end
