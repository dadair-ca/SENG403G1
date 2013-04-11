class CreateHolds < ActiveRecord::Migration
  def change
    create_table :holds do |t|
      t.integer :user_id
      t.integer :barcode_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
