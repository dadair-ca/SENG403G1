class RenameUserTypeToUserCategory < ActiveRecord::Migration
  def up
    rename_column :users, :type, :category
  end

  def down
    rename_column :users, :category, :type
  end
end
