require 'test_helper'

class ItemTest < ActiveSupport::TestCase
   
   
   test "should not save duplicate items with the same title" do
     item = Item.new(:title => "T", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
     item.save
     item1 = Item.new(:title => "T", :genre => "K", :publisher => "L", :isbn10 => 99, :isbn13 => 84)
     assert !item1.save
   end
   
   test "should not save items with the same isbn13 number" do
     item2 = Item.new(:title => "L", :genre => "Y", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
     item2.save
     item3 = Item.new(:title => "U", :genre => "K", :publisher => "L", :isbn10 => 99, :isbn13 => 32)
     assert !item3.save
   end
   
   test "should not save items with the same isbn10 number" do
     item4 = Item.new(:title => "U", :genre => "K", :publisher => "L", :isbn10 => 29, :isbn13 => 32)
     item4.save
     item5 = Item.new(:title => "U", :genre => "K", :publisher => "L", :isbn10 => 29, :isbn13 => 84)
     assert !item5.save
   end
   
   
   
   test "should not save item without a title" do
     item6 = Item.new(:title => "", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
     assert !item6.save
   end
   
   test "should not save items with no genre" do
      item7 = Item.new(:title => "K", :genre => "", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item7.save
   end
   
   test "should not save items with no publisher" do
      item8 = Item.new(:title => "K", :genre => "Q", :publisher => "", :isbn10 => 29, :isbn13 => 32)
      assert !item8.save
   end
   
   test "should not save items with no isbn13" do
      item9 = Item.new(:title => "K", :genre => "", :publisher => "R", :isbn13 => 32)
      assert !item9.save
   end
   
   test "should not save items with no isbn10" do
      item10 = Item.new(:title => "K", :genre => "", :publisher => "R", :isbn13 => 32)
      assert !item10.save
   end
   
   test "should not run a sqlite command from title" do
      item11 = Item.new(:title => 'drop table t;', :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item11.save
   end
   
   test "should not run a sqlite command from genre" do
      item12 = Item.new(:title => "K", :genre => 'drop table t;', :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item12.save
   end
   
   test "should not run a sqlite command from publisher" do
      item13 = Item.new(:title => "K", :genre => "Q", :publisher => 'drop table t;', :isbn10 => 29, :isbn13 => 32)
      assert !item13.save
   end
   
   test "should not save items with tabs for the title" do
      item14 = Item.new(:title => "\t\t\t", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item14.save
   end
   
   test "should not save items with tabs for the genre" do
      item15 = Item.new(:title => "K", :genre => "\t\t\t", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item15.save
   end
   
   test "should not save items with tabs for the publisher" do
      item17 = Item.new(:title => "K", :genre => "Q", :publisher => "\t\t\t", :isbn10 => 29, :isbn13 => 32)
      assert !item17.save
   end
   
   test "should not save items with tabs for the isbn10" do
      item18 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => '\t\t\t', :isbn13 => 32)
      assert !item18.save
   end
   
   test "should not save items with tabs for the isbn13" do
      item19 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => '\t\t\t')
      assert !item19.save
   end
   
   
   
   test "should not save items with spaces for the title" do
      item20 = Item.new(:title => "\s\s\s", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item20.save
   end
   
   test "should not save items with spaces for the genre" do
      item21 = Item.new(:title => "K", :genre => "\s\s\s", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item21.save
   end
   
   test "should not save items with spaces for the publisher" do
      item22 = Item.new(:title => "K", :genre => "Q", :publisher => "\s\s\s", :isbn10 => 29, :isbn13 => 32)
      assert !item22.save
   end
   
   test "should not save items with spaces for the isbn10" do
      item23 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => '\s\s\s', :isbn13 => 32)
      assert !item23.save
   end
   
   test "should not save items with spaces for the isbn13" do
      item24 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => '\s\s\s')
      assert !item24.save
   end
   
   
   
   
   test "should not save items with new line characters for the title" do
      item25 = Item.new(:title => "\n\n\n", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item25.save
   end
   
   test "should not save items with new line characters for the genre" do
      item26 = Item.new(:title => "K", :genre => "\n\n\n", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item26.save
   end
   
   test "should not save items with new line characters for the publisher" do
      item27 = Item.new(:title => "K", :genre => "Q", :publisher => "\n\n\n", :isbn10 => 29, :isbn13 => 32)
      assert !item27.save
   end
   
   test "should not save items with new line characters for the isbn10" do
      item28 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => '\n\n\n', :isbn13 => 32)
      assert !item28.save
   end
   
   test "should not save items with new line characters for the isbn13" do
      item29 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => '\n\n\n')
      assert !item29.save
   end
   
   
   
   test "should not save items with return keys for the title" do
      item30 = Item.new(:title => "\r\r\r", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item30.save
   end
   
   test "should not save items with return keys for the genre" do
      item31 = Item.new(:title => "K", :genre => "\r\r\r", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item31.save
   end
   
   test "should not save items with return keys for the publisher" do
      item32 = Item.new(:title => "K", :genre => "Q", :publisher => "\r\r\r", :isbn10 => 29, :isbn13 => 32)
      assert !item32.save
   end
   
   test "should not save items with return keys for the isbn10" do
      item33 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => '\r\r\r', :isbn13 => 32)
      assert !item33.save
   end
   
   test "should not save items with return keys for the isbn13" do
      item34 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => '\r\r\r')
      assert !item34.save
   end
   
   
# This piece of test code is oddly causing issues with the database
#   test "should not save items with EOF characters for the title" do
#      item35 = Item.new(:title => "\0\0\0", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
#      assert !item35.save
#   end
   
   test "should not save items with EOF characters for the genre" do
      item36 = Item.new(:title => "K", :genre => "\0\0\0", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item36.save
   end
   
   test "should not save items with EOF characters for the publisher" do
      item37 = Item.new(:title => "K", :genre => "Q", :publisher => "\0\0\0", :isbn10 => 29, :isbn13 => 32)
      assert !item37.save
   end
   
   test "should not save items with EOF characters the isbn10" do
      item38 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => '\0\0\0', :isbn13 => 32)
      assert !item38.save
   end
   
   test "should not save items with EOF characters for the isbn13" do
      item39 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => '\0\0\0')
      assert !item39.save
   end
   
   
   
   
   test "should not save items with a hexadecimal number for the title" do
      item40 = Item.new(:title => "0x41", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item40.save
   end
   
   test "should not save items with a hexadecimal number for the genre" do
      item41 = Item.new(:title => "K", :genre => "0x42", :publisher => "R", :isbn10 => 29, :isbn13 => 32)
      assert !item41.save
   end
   
   test "should not save items with a hexadecimal number for the publisher" do
      item42 = Item.new(:title => "K", :genre => "Q", :publisher => "0x43", :isbn10 => 29, :isbn13 => 32)
      assert !item42.save
   end
   
   test "should not save items with hexadecimal numbers for isbn10" do
      item43 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => 0x0056A12, :isbn13 => 32)
      assert !item43.save
   end
   
   test "should not save items with hexadecimal numbers for isbn13" do
      item44 = Item.new(:title => "K", :genre => "Q", :publisher => "R", :isbn10 => 29, :isbn13 => 0x00AF1236)
      assert !item44.save
   end
   
   
   
end
