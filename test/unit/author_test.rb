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
        author = Author.new(:given_name => "\t\t\t", :surname => "HillBilly")
        assert !author.save
    end

    test "should not insert author with space characters as its given name" do
        author = Author.new(:given_name => "\s\s\s", :surname => "Claw")
        assert !author.save
    end
    
    test "should not insert author with next line characters as its surname" do
        author = Author.new(:given_name => "Johnson", :surname => "\n\n\n")
        assert !author.save
    end
    
    test "should not insert author with tab characters as its surname" do
        author = Author.new(:given_name => "Marlene", :surname => "\t\t\t")
        assert !author.save
    end
    
    test "should not insert author with space characters as its surname" do
        author = Author.new(:given_name => "Stephiane", :surname => "\s\s\s")
        assert !author.save
    end
    
    test "should not save duplicate authors" do
        author1 = Author.new(:given_name => "Mike", :surname => "Author")
        author1.save
        author2 = Author.new(:given_name => "Mike", :surname => "Author")
        assert !author2.save
    end

    test "this test is duplicated" do
        author1 = Author.new(:given_name => "Mike", :surname => "Author")
        author1.save
        author2 = Author.new(:given_name => "Mike", :surname => "Author")
        assert !author2.save
    end

end
