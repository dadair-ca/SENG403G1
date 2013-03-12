class CreateMailers < ActiveRecord::Migration
  def change
    create_table :mailers do |t|
      t.string :subject
      t.text :body
      t.timestamps
    end
  end
end
