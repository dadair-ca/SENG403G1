# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

lotrs = Item.create([
  { :title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000"},
  { :title => "The Two Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1111111111111", :isbn10 => "1111111111"},
  { :title => "The Return of the King", :genre => "Fantasy", :year => 1955, :publisher => "George Allen & Unwin", :isbn13 => "2222222222222", :isbn10 => "2222222222"}
])

tolkien = Author.create(:given_name => "J.R.R.", :surname => "Tolkien")
tolkien.items = lotrs

#Remember that minimum password requirement is 6 characters
david = User.create(:category => 0, :given_name => "David", :surname => "Adair", :email => "notreal@fake.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
shena = User.create(:category => 1, :given_name => "Shena", :surname => "Fortozo", :email => "fake@fake.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
User.create(:category => 2, :given_name => "Gellert", :surname => "Kispal", :email => "false@fake.com", :password => "dddeeefff", :password_confirmation => "aaabbbccc")
User.create(:category => 2, :given_name => "Sydney", :surname => "Pratte", :email => "nottrue@fake.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
User.create(:category => 1, :given_name => "Ho Wai", :surname => "Yung", :email => "notnotfalse@fake.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")

Item.first.physical_items.create(:barcode_id => 111)
Item.first.physical_items.create(:barcode_id => 222)
Item.first.physical_items.create(:barcode_id => 333)
Item.find(2).physical_items.create(:barcode_id => 444)

Rental.create(:user_id => david.id, :barcode_id => 111, :renewals => 1, :return_date => 10.days.from_now, :rent_date => Time.now)
Rental.create(:user_id => shena.id, :barcode_id => 222, :renewals => 2, :return_date => 20.days.from_now, :rent_date => Time.now)
Rental.create(:user_id => shena.id, :barcode_id => 333, :renewals => 2, :return_date => 15.days.from_now, :rent_date => Time.now)
Rental.create(:user_id => shena.id, :barcode_id => 444, :renewals => 3, :return_date => 30.days.ago, :rent_date => 60.days.ago)
