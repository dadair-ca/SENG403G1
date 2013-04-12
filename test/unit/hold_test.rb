require 'test_helper'

class HoldTest < ActiveSupport::TestCase
   test "should save hold when all info is provded and correct" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold = Hold.new(:user_id => user.id, :barcode_id => 111, :start_date => Time.now, :end_date => 10.days.from_now)
      assert hold.save
   end

   test "should not save hold when user ID does not exist" do
      user_id = 1000
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold = Hold.new(:user_id => user_id, :barcode_id => 111, :start_date => Time.now, :end_date => 10.days.from_now)
      assert !hold.save
   end

   test "should not save rental without start date" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold = Hold.new(:user_id => user.id, :barcode_id => 111, :end_date => 10.days.from_now)
      assert !hold.save
   end

   test "should not save rental without end date" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold = Hold.new(:user_id => user.id, :barcode_id => 111, :start_date => Time.now)
      assert !hold.save
   end

   test "should not save rental without a user id" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold = Hold.new(:barcode_id => 111, :start_date => Time.now, :end_date => 10.days.from_now)
      assert !hold.save
   end

   test "should not save rental without a barcode id" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      hold = Hold.new(:user_id => user.id, :start_date => Time.now, :end_date => 10.days.from_now)
      assert !hold.save
   end
end
