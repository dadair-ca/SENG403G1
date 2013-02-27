require 'test_helper'

class PhysicalItemTest < ActiveSupport::TestCase
   
   test "should create a new physical item when there was none previously" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem = item.physical_items.new(:barcode_id => 100000)
     physItem.save
     assert physItem.save
   end

   test "should create a new physical item when there is some already" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => 100000)
     physItem1.save
     physItem2 = item.physical_items.new(:barcode_id => 100001)
     physItem2.save
     assert physItem2.save
   end
   
   test "should not save duplicate physical items (ie. barcodes)" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => 100000)
     physItem1.save
     physItem2 = item.physical_items.new(:barcode_id => 100000)
     assert !physItem2.save
   end
   
   
end
