class CreateMailers < ActiveRecord::Migration
  def change
    create_table :mailers do |t|
      t.integer :id
      t.string :subject
      t.string :body

      t.timestamps
    end
  end
end
