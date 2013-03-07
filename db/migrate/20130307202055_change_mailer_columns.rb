class ChangeMailerColumns < ActiveRecord::Migration
  def change
	change_column :mailers, :body, :text
    add_column :mailers, :sent_date, :datetime
  end
end
