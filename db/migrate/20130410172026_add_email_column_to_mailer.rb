class AddEmailColumnToMailer < ActiveRecord::Migration
  def change
    add_column :mailers, :email, :String
  end
end
