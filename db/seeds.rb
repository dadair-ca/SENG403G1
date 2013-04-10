# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

require 'populator'
require 'faker'

#Remember that minimum password requirement is 6 characters
#Creating hard coded users
# 0 means - regular user
# 1 means - librarian
# 2 means - admin
david = User.create(:category => 0, :given_name => "David", :surname => "Adair", :email => "david@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
shena = User.create(:category => 1, :given_name => "Shena", :surname => "Fortozo", :email => "shena@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
User.create(:category => 2, :given_name => "Gellert", :surname => "Kispal", :email => "gellert@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
User.create(:category => 2, :given_name => "Sydney", :surname => "Pratte", :email => "sydney@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
User.create(:category => 1, :given_name => "Ho Wai", :surname => "Yung", :email => "howai@weblib.com", :password => "aaabbbccc", :password_confirmation => "aaabbbccc")

#Creating 100 random regular users
1.upto(100) do |k|
    User.create(:category => 0, :given_name => Faker::Name.first_name, :surname => Faker::Name.last_name, :email => Faker::Internet.free_email, :password => "aaabbbccc", :password_confirmation => "aaabbbccc")
end

#Create a few hard coded items (books)
lotrs = Item.create([
  { :title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000000", :isbn10 => "1000000000"},
  { :title => "The Two Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin",             :isbn13 => "1000000000001", :isbn10 => "1000000001"},
  { :title => "The Three Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000002", :isbn10 => "1000000002"},
  { :title => "The Four Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin",  :isbn13 => "1000000000003", :isbn10 => "1000000003"},
  { :title => "The Five Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin",  :isbn13 => "1000000000004", :isbn10 => "1000000004"},
  { :title => "The Six Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin",   :isbn13 => "1000000000005", :isbn10 => "1000000005"},
  { :title => "The Seven Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000006", :isbn10 => "1000000006"},
  { :title => "The Eight Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "1000000000007", :isbn10 => "1000000007"},
  { :title => "The Nine Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin",  :isbn13 => "1000000000008", :isbn10 => "1000000008"},
  { :title => "The Ten Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin",         :isbn13 => "1000000000009", :isbn10 => "1000000009"},
  { :title => "The Eleven Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin",      :isbn13 => "1000000000010", :isbn10 => "1000000010"},
  { :title => "The Twelve Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin",      :isbn13 => "1000000000011", :isbn10 => "1000000011"},
  { :title => "The Return of the King", :genre => "Fantasy", :year => 1955, :publisher => "George Allen & Unwin", :isbn13 => "1000000000012", :isbn10 => "1000000012"}
])

tolkien = Author.create(:given_name => "J.R.R.", :surname => "Tolkien")
tolkien.items = lotrs


#Create 400 items (books) where each author can write up to 12 books. Therfore the number of authors created is variable, since it depends on how many books each of them write.
#The lower bound on the number of authors is 400/12 where each author writes 12 books and the upper bound on the number of authors is 400 in the case where each author only writes one book.
numberOfItems = 0
genreSelection = ["Action", "Advanture", "Comedy", "Fantasy", "Horror"]
while numberOfItems < 400 do
    writer = Author.create(:given_name => Faker::Name.first_name, :surname => Faker::Name.last_name)
    numberOfBooksWritten = 1 + rand(12)
    createdItems = Array.new
    i = 0
    while i < numberOfBooksWritten do
        isbn13Number = 1000000000013 + rand(8999999999997)
        isbn10Number = 1000000013 + rand(8999999997)
        createdItems << Item.create(:title => Faker::Company.name, :genre => genreSelection[rand(4)], :year => 1930 + rand(83), :publisher => Faker::Name.first_name, :isbn13 => isbn13Number, :isbn10 => isbn10Number)
        i = i + 1
        numberOfItems = numberOfItems + 1
    end
    writer.items = createdItems
end

#Create physical copies of each existing item and assign it a unique barcode id
#Once that's done each physical copy has a 40% chance of being rented by a user.
#The specific user chosen for each rental is randomly selected
barcode_id_number = 1000000
Item.all.each do |item|
    numberOfCopies = 1 + rand(15)
    j = 0
    while j < numberOfCopies do
        item.physical_items.create(:barcode_id => barcode_id_number)
        
        isRented = rand(99)
        
        if isRented < 40
            Rental.create(:user_id => User.find(1 + rand(99)).id, :barcode_id => barcode_id_number, :renewals => 1, :return_date => 10.days.from_now, :rent_date => Time.now)
        end
        
        barcode_id_number = barcode_id_number + 1
        j = j + 1
    end
end