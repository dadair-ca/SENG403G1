require 'test_helper'

class ItemTest < ActiveSupport::TestCase
   test "should not save item without title" do
     item = Item.new(:title => "")
     assert !item.save
   end
   
   
   test "should not save duplicate items" do
     item1 = Item.new(:title => "t")
     item1.save
     item2 = Item.new(:title => "t")
     assert !item2.save
   end
   
   test "should not save items with the same isbn13 number" do
      item3 = Item.new(:isbn13 => 29)
      item3.save
      item4 = Item.new(:isbn13 => 29)
      assert !item4.save
   end
   
   test "should not save items with the same isbn10 number" do
      item5 = Item.new(:isbn10 => 32)
      item5.save
      item6 = Item.new(:isbn10 => 32)
      assert !item6.save
   end
   
   test "should not save items with the same title" do
      item7 = Item.new(:title => "L")
      item7.save
      item8 = Item.new(:title => "L")
      assert !item8.save
   end
   
   test "should not save items with no genre" do
      item9 = Item.new(:genre => "")
      assert !item9.save
   end
   
   test "should not save items with no publisher" do
      item11 = Item.new(:publisher => "")
      assert !item11.save
   end
   
   test "should not save items with no isbn13" do
      item12 = Item.new(:isbn10 => 32)
      assert !item12.save
   end
   
   test "should not save items with no isbn10" do
      item13 = Item.new(:isbn13 => 29)
      assert !item13.save
   end
   
   
end
