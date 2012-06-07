class AddPriceToVariant < ActiveRecord::Migration
  def change
    add_column(:variants, :price, :integer)
  end
end
