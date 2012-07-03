class CreateRelatedProducts < ActiveRecord::Migration
  def change
    create_table :related_products do |t|
      t.integer :related_product_id
      t.integer :product_id
      t.timestamps
    end
  end
end
