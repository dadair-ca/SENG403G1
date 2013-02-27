require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
    test "should not insert blank author" do
        author = Author.new
        assert !author.save
    end

    test "should insert normal author" do
        author = Author.new(:given_name => "John", :surname => "Dude")
        assert author.save
    end

    test "should not insert author with no given name" do
        author = Author.new(:given_name => "Jack", :surname => "")
        assert !author.save
    end

    test "should not insert author with no surname" do
        author = Author.new(:given_name => "", :surname => "Jackson")
        assert !author.save
    end
    
    
    test "should not insert author with next line characters as its given name" do
        author = Author.new(:given_name => "\n\n\n", :surname => "Jackson")
        assert !author.save
    end
    
    test "should not insert author with tab characters as its given name" do
        author = Author.new(:given_name => "\t\t\t", :surname => "Jackson")
        assert !author.save
    end
    
    test "should not insert author with space characters as its given name" do
        author = Author.new(:given_name => "\s\s\s", :surname => "Jackson")
        assert !author.save
    end
    
#    test "should not insert author with backspace characters as its given name" do
#        author = Author.new(:given_name => "\b\b\b", :surname => "Jackson")
#        assert !author.save
#    end
     
#    test "should not insert author with termination characters as its given name" do
#        author = Author.new(:given_name => "\0\0\0", :surname => "Jackson")
#        assert !author.save
#    end
    
#    test "associate author with an item" do
#        author = Author.new(:given_name => "Frank", :surname => "Jackson")
#		author.save
#        item = Item.new(:title => "one", :genre => "yes", :publisher => "no", :isbn10 => 99, :isbn13 => 98)
#		item.save
#        item.author = author
#        assert !item.save
#    end


#   test "should not save duplicate authors" do
#     author1 = Author.new(:given_name => "Mike", :surname => "Author")
#     author1.save
#     author2 = Author.new(:given_name => "Mike", :surname => "Author")
#     assert !author2.save
#   end


end
