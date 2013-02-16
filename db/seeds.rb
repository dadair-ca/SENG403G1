# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

hobbit = Item.new(:title => "The Hobbit", :genre => "Fantasy", :isbn13 => 13, :isbn10 => 10)
if hobbit.save
  hobbit.authors.create(:given_name => "J.R.R.", :surname => "Tolkien")
end
