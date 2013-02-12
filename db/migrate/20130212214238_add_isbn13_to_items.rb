class AddIsbn13ToItems < ActiveRecord::Migration
  def change
    add_column :items, :isbn13, :text
  end
end
