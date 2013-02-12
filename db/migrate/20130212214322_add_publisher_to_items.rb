class AddPublisherToItems < ActiveRecord::Migration
  def change
    add_column :items, :publisher, :text
  end
end
