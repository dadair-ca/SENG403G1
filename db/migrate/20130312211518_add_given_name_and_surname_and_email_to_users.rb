class AddGivenNameAndSurnameAndEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :given_name, :text
    add_column :users, :surname, :text
    add_column :users, :email, :text
  end
end
