class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :assetable_type
      t.integer :assetable_id
#      t.attachment :asset
      t.string :type
      t.string :media_type
      t.timestamps
    end
  end
end
