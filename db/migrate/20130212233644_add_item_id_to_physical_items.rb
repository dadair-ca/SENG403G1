class AddItemIdToPhysicalItems < ActiveRecord::Migration
  def change
    add_column :physical_items, :item_id, :integer
  end
end
