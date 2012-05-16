class AddPositionToOptionValues < ActiveRecord::Migration
  def change
    add_column(:option_values, :position, :integer)
  end
end
