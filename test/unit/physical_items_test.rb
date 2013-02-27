require 'test_helper'

class PhysicalItemTest < ActiveSupport::TestCase

   test "should not save duplicate physical items (ie. barcodes)" do
     item = Item.new(:title => "Title", :genre => "Genre", :publisher => "Publisher", :isbn13 => 13, :isbn10 => 10)
     item.save
     physItem1 = item.physical_items.new(:barcode_id => 100000)
     physItem1.save
     physItem2 = item.physical_items.new(:barcode_id => 100000)
     assert !physItem2.save
   end
   
end
