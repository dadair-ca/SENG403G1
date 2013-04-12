require 'test_helper'

class HoldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
 
  test "should not save hold without a start hold date" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold1 = Hold.new(:user_id => user.id, :barcode_id => 111, :start_date => Time.now)
      assert !hold1.save
   end
 
  test "should not save hold without a end date" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold1 = Hold.new(:user_id => user.id, :barcode_id => 111, :end_date => 2.days.from_now)
      assert !hold1.save
   end

   test "should not save hold with user ID does not exist" do
      user_id = 100
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold1 = Hold.new(:user_id => user_id, :barcode_id => 111, :end_date => 2.days.from_now, :start_date => Time.now)
      assert !hold1.save
   end
   
   
   test "should not have duplicate holds" do
      user1 = users(:one)
      user2 = users(:two)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold1 = Hold.create(:user_id => user1.id, :barcode_id => 111, :end_date => 2.days.from_now, :start_date => Time.now)
      hold2 = Hold.new(:user_id => user2.id, :barcode_id => 111, :end_date => 2.days.from_now, :start_date => Time.now)
      assert !hold2.save
   end  
  
end
