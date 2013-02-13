class CreatePhysicalItems < ActiveRecord::Migration
  def change
    create_table :physical_items do |t|
      t.integer :barcode_id

      t.timestamps
    end
  end
end
