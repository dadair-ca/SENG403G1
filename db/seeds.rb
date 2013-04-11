# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

require 'populator'
require 'faker'


lotrs = Item.create([
  { :title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000000", :isbn10 => "1000000000"},
  { :title => "The Two Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000001", :isbn10 => "1000000001"},
  { :title => "The Three Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000002", :isbn10 => "1000000002"},
  { :title => "The Four Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000003", :isbn10 => "1000000003"},
  { :title => "The Five Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000004", :isbn10 => "1000000004"},
  { :title => "The Six Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000005", :isbn10 => "1000000005"},
  { :title => "The Seven Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000006", :isbn10 => "1000000006"},
  { :title => "The Eight Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000007", :isbn10 => "1000000007"},
  { :title => "The Nine Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000008", :isbn10 => "1000000008"},
  { :title => "The Ten Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000009", :isbn10 => "1000000009"},
  { :title => "The Eleven Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000010", :isbn10 => "1000000010"},
  { :title => "The Twelve Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000012", :isbn10 => "1000000012"},
  { :title => "The Return of the King", :genre => "Fantasy", :year => 1955, :publisher => "George Allen & Unwin", :isbn13 => "1000000000011", :isbn10 => "1000000011"}
])

tolkien = Author.create(:given_name => "J.R.R.", :surname => "Tolkien")
tolkien.items = lotrs

numberOfItems = 0

while numberOfItems < 1000 do
    writer = Author.create(:given_name => Faker::Name.first_name, :surname => Faker::Name.last_name)
    numberOfBooksAuthored = 1 + rand(12)

    createdItems = Array.new
    
    i = 0
    while i < numberOfBooksAuthored do
        createdItems << Item.create(:title => Faker::Lorem.sentence, :genre => "Fantasy", :year => 1930 + rand(83), :publisher => Faker::Name.first_name, :isbn13 => 1000000000002 + rand(8999999999997), :isbn10 => 1000000002 + rand(8999999997))

        i = i + 1
        numberOfItems = numberOfItems + 1
    end

    writer.items = createdItems
end


#1.upto(100) do |i|
#    author = Author.create(:given_name => Faker::Name.first_name, :surname => Faker::Name.last_name)
#end

#Remember that minimum password requirement is 6 characters
david = User.create(:category => 0, :given_name => "David", :surname => "Adair", :email => "david@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
shena = User.create(:category => 1, :given_name => "Shena", :surname => "Fortozo", :email => "shena@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
User.create(:category => 2, :given_name => "Gellert", :surname => "Kispal", :email => "gellert@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
User.create(:category => 2, :given_name => "Sydney", :surname => "Pratte", :email => "sydney@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
User.create(:category => 1, :given_name => "Ho Wai", :surname => "Yung", :email => "howai@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")

1.upto(100) do |i|
    User.create(:category => 0, :given_name => Faker::Name.first_name, :surname => Faker::Name.last_name, :email => Faker::Internet.free_email, :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
end


Item.first.physical_items.create(:barcode_id => 111)
Item.first.physical_items.create(:barcode_id => 222)
Item.first.physical_items.create(:barcode_id => 333)
Item.find(2).physical_items.create(:barcode_id => 444)

Rental.create(:user_id => david.id, :barcode_id => 111, :renewals => 1, :return_date => 10.days.from_now, :rent_date => Time.now)
Rental.create(:user_id => shena.id, :barcode_id => 222, :renewals => 2, :return_date => 20.days.from_now, :rent_date => Time.now)
Rental.create(:user_id => shena.id, :barcode_id => 333, :renewals => 2, :return_date => 15.days.from_now, :rent_date => Time.now)
Rental.create(:user_id => shena.id, :barcode_id => 444, :renewals => 3, :return_date => 30.days.ago, :rent_date => 60.days.ago)
