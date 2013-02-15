require 'test_helper'

class ItemTest < ActiveSupport::TestCase
   test "should not save item without title" do
     item = Item.new
     assert !item.save
   end
   
   
   test "should not save duplicate items" do
     item1 = Item.new(:title => "t", :genre => "g", :isbn13 => 13, :isbn10 => 10)
     item1.save
     item2 = Item.new(:title => "t", :genre => "g", :isbn13 => 13, :isbn10 => 10)
     assert !item2.save
   end
   
   
end

       
