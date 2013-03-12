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

User.create(:category => 0, :given_name => "David", :surname => "Adair", :email => "notreal@fake.com")
User.create(:category => 1, :given_name => "Shena", :surname => "Fortozo", :email => "fake@fake.com")
User.create(:category => 2, :given_name => "Gellert", :surname => "Kispal", :email => "false@fake.com")
User.create(:category => 2, :given_name => "Sydney", :surname => "Pratte", :email => "nottrue@fake.com")
User.create(:category => 1, :given_name => "Ho Wai", :surname => "Yung", :email => "notnotfalse@fake.com")
