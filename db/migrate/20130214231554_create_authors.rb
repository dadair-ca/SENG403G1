class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.text :given_name
      t.text :surname

      t.timestamps
    end
  end
end
