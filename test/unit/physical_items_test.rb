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
   
   test "should not save a physical item with new line characters" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => '\n\n\n')
     assert !physItem1.save
   end
   
   test "should not save a physical item with tabs" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => '\t\t\t')
     assert !physItem1.save
   end
   
   test "should not save a physical item with spaces" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => '\s\s\s')
     assert !physItem1.save
   end
   
   test "should not save a physical item with EOF characters" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => '\0\0\0')
     assert !physItem1.save
   end
   
   test "should not save a physical item with a string" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => 'defevvds')
     assert !physItem1.save
   end
   
   test "should not save a physical item with a mixed number and string" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => 'd5f4t8g2g5')
     assert !physItem1.save
   end
   
   test "should not save a physical item with a hexadecimal value" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => '0x000000000000006A')
     assert !physItem1.save
   end
end
