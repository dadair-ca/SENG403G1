class AddAuthorIdToItem < ActiveRecord::Migration
  def change
    add_column :items, :author_id, :integer
  end
end
