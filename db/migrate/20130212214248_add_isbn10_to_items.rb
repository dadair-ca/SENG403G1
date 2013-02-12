class AddIsbn10ToItems < ActiveRecord::Migration
  def change
    add_column :items, :isbn10, :text
  end
end
