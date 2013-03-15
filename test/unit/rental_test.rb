require 'test_helper'

class RentalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
   test "should not save rental without renewal amount" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      rental1 = Rental.new(:user_id => user.id, :barcode_id => 111, :return_date => 10.days.from_now, :rent_date => Time.now)
      assert !rental1.save
   end
 
  test "should not save rental without date of rental" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      rental1 = Rental.new(:user_id => user.id, :barcode_id => 111, :renewals => 1, :return_date => 10.days.from_now)
      assert !rental1.save
   end
 
  test "should not save rental without a return date" do
      user = users(:one)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      rental1 = Rental.new(:user_id => user.id, :barcode_id => 111, :renewals => 1, :rent_date => Time.now)
      assert !rental1.save
   end

   test "should not save rental with user ID does not exist" do
      user_id = 100
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      rental1 = Rental.new(:user_id => user_id, :barcode_id => 111, :renewals => 1, :return_date => 10.days.from_now, :rent_date => Time.now)
      assert !rental1.save
   end
   
   test "should not save rental with barcode ID does not exist" do
      user = users(:one)
      barcode_id = 100
      rental1 = Rental.new(:user_id => user.id, :barcode_id => barcode_id, :renewals => 1, :return_date => 10.days.from_now, :rent_date => Time.now)
      assert !rental1.save
   end
   
   test "should not have duplicate rentals" do
      user1 = users(:one)
      user2 = users(:two)
      Item.create(:title => "The Fellowship of the Ring", :genre => "Fantasy", :year => 1954, :publisher => "George Allen & Unwin", :isbn13 => "0000000000000", :isbn10 => "0000000000")
      Item.first.physical_items.create(:barcode_id => 111)
      rental1 = Rental.create(:user_id => user1.id, :barcode_id => 111, :renewals => 1, :return_date => 10.days.from_now, :rent_date => Time.now)
      rental2 = Rental.new(:user_id => user2.id, :barcode_id => 111, :renewals => 1, :return_date => 10.days.from_now, :rent_date => Time.now)
      assert !rental2.save
   end
end
