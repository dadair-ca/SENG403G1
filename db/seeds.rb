# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
tolkien = Author.create(:given_name => "J.R.R.",
                        :surname => "Tolkien")

tolkien.items.create(:title => "The Hobbit",
                     :genre => "Fantasy",
                     :isbn13 => 13,
                     :isbn10 => 10,
                     :year => 1937,
                     :publisher => "George Allen & Unwin")

tolkien.items.first.physical_items.create(:barcode_id => 1)
tolkien.items.first.physical_items.create(:barcode_id => 2)
tolkien.items.first.physical_items.create(:barcode_id => 3)

tolkien.items.create(:title => "The Fellowship of the Ring",
                   :genre => "Fantasy",
                   :isbn13 => 14,
                   :isbn10 => 11,
                   :year => 1954,
                   :publisher => "George Allen & Unwin")

tolkien.items.create(:title => "The Two Towers",
                  :genre => "Fantasy",
                  :isbn13 => 15,
                  :isbn10 => 12,
                  :year => 1954,
                  :publisher => "George Allen & Unwin")

tolkien.items.create(:title => "The Return of the King",
                    :genre => "Fantasy",
                    :isbn13 => 16,
                    :isbn10 => 13,
                    :year => 1954,
                    :publisher => "George Allen & Unwin")

rowling = Author.create(:given_name => "J.K.",
                        :surname => "Rowling")

rowling.items.create(:title => "Harry Potter and the Philosopher's Stone",
                     :genre => "Fantasy", 
                     :isbn13 => "17",
                     :isbn10 => "0747532699",
                     :year => 1997,
                     :publisher => "Bloomsbury")

rowling.items.create(:title => "Harry Potter and the Chamber of Secrets",
                     :genre => "Fantasy", 
                     :isbn13 => "18",
                     :isbn10 => "0747538492",
                     :year => 1998,
                     :publisher => "Bloomsbury")
