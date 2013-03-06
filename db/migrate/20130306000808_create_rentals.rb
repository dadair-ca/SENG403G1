class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.integer :user_id
      t.integer :barcode_id
      t.integer :renewals
      t.datetime :return_date
      t.datetime :rent_date

      t.timestamps
    end
  end
end
