class RemoveItemIdFromAuthor < ActiveRecord::Migration
  def up
    remove_column :authors, :item_id
  end

  def down
    add_column :authors, :item_id, :integer
  end
end
