require 'test_helper'

class ItemTest < ActiveSupport::TestCase
   test "should not save item without title" do
     item = Item.new(:title => "")
     assert !item.save
   end
   
   
   test "should not save duplicate items" do
     item1 = Item.new(:title => "t", :genre => "g", :isbn13 => 13, :isbn10 => 10)
     item1.save
     item2 = Item.new(:title => "t", :genre => "g", :isbn13 => 13, :isbn10 => 10)
     assert !item2.save
   end
   
   test "should not save items with the same isbn13 number" do
      item3 = Item.new(:title => "L", :genre => "R", :publisher => "T", :isbn13 => 29, :isbn10 => 32)
      item3.save
      item4 = Item.new(:title => "Y", :genre => "K", :publisher => "P", :isbn13 => 29, :isbn10 => 32)
      assert !item4.save
   end
end
