require 'test_helper'

class ItemTest < ActiveSupport::TestCase
   
   
   test "should not save duplicate items with the same information" do
     item = Item.new(:title => "T", :genre => "K", :year => 1969, :publisher => "L", :isbn10 => 29, :isbn13 => 32)
     item.save
     item1 = Item.new(:title => "T", :genre => "K", :year => 1969, :publisher => "L", :isbn10 => 29, :isbn13 => 32)
     assert !item1.save
   end
   
   test "should not save items with the same isbn13 number" do
     item2 = Item.new(:title => "L", :genre => "Y", :year => 1969, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
     item2.save
     item3 = Item.new(:title => "U", :genre => "K", :year => 1945, :publisher => "L", :isbn10 => 99, :isbn13 => 32)
     assert !item3.save
   end
   
   test "should not save items with the same isbn10 number" do
     item4 = Item.new(:title => "U", :genre => "K", :year => 1962, :publisher => "L", :isbn10 => 29, :isbn13 => 32)
     item4.save
     item5 = Item.new(:title => "Z", :genre => "O", :year => 1692, :publisher => "T", :isbn10 => 29, :isbn13 => 84)
     assert !item5.save
   end

   test "should not save item without a title" do
     item6 = Item.new(:title => "", :genre => "Q", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
     assert !item6.save
   end
   
   test "should not save items with no genre" do
      item7 = Item.new(:title => "K", :genre => "", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item7.save
   end
   
   test "should not save items with no publisher" do
      item8 = Item.new(:title => "K", :genre => "Q", :year => 1989, :publisher => "", :isbn10 => 29, :isbn13 => 32)
      assert !item8.save
   end
   
   test "should not save items with no year" do
      item9 = Item.new(:title => "K", :genre => "Q", :publisher => "", :isbn10 => 29, :isbn13 => 32)
      assert !item9.save
   end
   
   test "should not save items with no isbn13" do
      item10 = Item.new(:title => "K", :genre => "", :year => 1989, :publisher => "R", :isbn13 => 32)
      assert !item10.save
   end
   
   test "should not save items with no isbn10" do
      item11 = Item.new(:title => "K", :genre => "", :year => 1989, :publisher => "R", :isbn13 => 32)
      assert !item11.save
   end

   test "should not save items with tabs for the title" do
      item15 = Item.new(:title => "\t\t\t", :genre => "Q", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item15.save
   end
   
   test "should not save items with tabs for the genre" do
      item16 = Item.new(:title => "K", :genre => "\t\t\t", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item16.save
   end
   
   test "should not save items with tabs for the year" do
      item16 = Item.new(:title => "K", :genre => "Q", :year => '\t\t\t', :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item16.save
   end
   
   test "should not save items with tabs for the publisher" do
      item17 = Item.new(:title => "K", :genre => "Q", :year => 1989, :publisher => "\t\t\t", :isbn10 => 29, :isbn13 => 32)
      assert !item17.save
   end

   test "should not save items with spaces for the title" do
      item20 = Item.new(:title => "\s\s\s", :genre => "Q", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item20.save
   end
   
   test "should not save items with spaces for the genre" do
      item21 = Item.new(:title => "K", :genre => "\s\s\s", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item21.save
   end
   
   test "should not save items with spaces for the year" do
      item22 = Item.new(:title => "K", :genre => "Q", :year => '\s\s\s', :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item22.save
   end
   
   test "should not save items with spaces for the publisher" do
      item23 = Item.new(:title => "K", :genre => "Q", :year => 1989, :publisher => "\s\s\s", :isbn10 => 29, :isbn13 => 32)
      assert !item23.save
   end

   test "should not save items with new line characters for the title" do
      item26 = Item.new(:title => "\n\n\n", :genre => "Q", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item26.save
   end
   
   test "should not save items with new line characters for the genre" do
      item27 = Item.new(:title => "K", :genre => "\n\n\n", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item27.save
   end
   
   test "should not save items with new line characters for the year" do
      item28 = Item.new(:title => "K", :genre => "Q", :year => '\n\n\n', :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item28.save
   end
   
   test "should not save items with new line characters for the publisher" do
      item29 = Item.new(:title => "K", :genre => "Q", :year => 1989, :publisher => "\n\n\n", :isbn10 => 29, :isbn13 => 32)
      assert !item29.save
   end
   
   test "should not save items with return characters for the title" do
      item32 = Item.new(:title => "\r\r\r", :genre => "Q", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item32.save
   end
   
   test "should not save items with return characters for the genre" do
      item33 = Item.new(:title => "K", :genre => "\r\r\r", :year => 1989, :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item33.save
   end
   
   test "should not save items with return characters for the year" do
      item33 = Item.new(:title => "K", :genre => "Q", :year => '\r\r\r', :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item33.save
   end
   
   test "should not save items with return characters for the publisher" do
      item34 = Item.new(:title => "K", :genre => "Q", :year => 1989, :publisher => "\r\r\r", :isbn10 => 29, :isbn13 => 32)
      assert !item34.save
   end
   
   test "should not save items with EOF characters for the year" do
      item39 = Item.new(:title => "K", :genre => "Q", :year => '\0\0\0', :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item39.save
   end
   
   test "should not save items with a string for the year" do
      item48 = Item.new(:title => "K", :genre => "Q", :year => 'rtyghjykl', :publisher => "R", :isbn10 => 29, :isbn13 => 36)
      assert !item48.save
   end
end
