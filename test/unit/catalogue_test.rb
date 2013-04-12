require 'test_helper'

class CatalogueTest < ActiveSupport::TestCase
  def setup
    Item.delete_all
    Author.delete_all
  
    @author1 = Author.create(:given_name => "J.R.R.", :surname => "Tolkien")
    @author2 = Author.create(:given_name => "Alberta", :surname => "Rosario")
    @author3 = Author.create(:given_name => "John", :surname => "Dude")

    @book1 = Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => 1000000000000, :isbn10 => 1000000000)
    @book1.author = @author1
    @book1.save
    
    @book2 = Item.create(:title => "The Two Towers", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => 1000000000001, :isbn10 => 1000000001)
    @book2.author = @author1
    @book2.save
    
    @book3 = Item.create(:title => "Marquardt Group", :genre => "Action", :year => 1955, :publisher => "Chasity", :isbn10 => 5087495733132, :isbn13 => 1859323367)
    @book3.author = @author3
    @book3.save

    @params = Hash.new
  end
  
  test "should find a specific item when searching by titles" do
    @params[:search] = "fellowship"
    @params[:search_type] = "title"

    @items = Catalogue.search(@params)
    
    assert (@items.include? @book1)
  end
  
  test "should find a specific item when searching by genre" do
    @params[:search] = "action"
    @params[:search_type] = "genre"

    @items = Catalogue.search(@params)
    
    assert (@items.include? @book3)
    assert !(@items.include? @book2)
  end
  
  test "should find a specific item when searching by year" do
    @params[:search] = 1955
    @params[:search_type] = "year"

    @items = Catalogue.search(@params)
    
    assert (@items.include? @book3)
    assert !(@items.include? @book2)
    assert !(@items.include? @book1)
  end
  
  test "should find a specific item when searching by publisher" do
    @params[:search] = "george"
    @params[:search_type] = "publisher"

    @items = Catalogue.search(@params)
    
    assert !(@items.include? @book3)
    assert (@items.include? @book2)
    assert (@items.include? @book1)
   
  end
  
  test "should find a specific item when searching by author" do
    @params[:search] = "J.R.R."
    @params[:search_type] = "author"

    @items = Catalogue.search(@params)
    
    assert !(@items.include? @book3)
    assert (@items.include? @book2)
    assert (@items.include? @book1)
   
  end
  
  test "should find a specific item when searching by isbn13" do
    @params[:search] = 0000
    @params[:search_type] = "isbn13"

    @items = Catalogue.search(@params)
    
    assert !(@items.include? @book3)
    assert (@items.include? @book2)
    assert (@items.include? @book1)
   
  end
  
  test "should find a specific item when searching by isbn10" do
    @params[:search] = 8749
    @params[:search_type] = "isbn10"

    @items = Catalogue.search(@params)
    
    assert (@items.include? @book3)
    assert !(@items.include? @book2)
    assert !(@items.include? @book1)
   
  end
end



