class CreateAuthoreds < ActiveRecord::Migration
  def change
    create_table :authoreds do |t|
      t.integer :item_id
      t.integer :author_id

      t.timestamps
    end
  end
end
