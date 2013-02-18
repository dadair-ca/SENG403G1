class RemoveAuthoredTable < ActiveRecord::Migration
  def up
    drop_table :authoreds
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
