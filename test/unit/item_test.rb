require 'test_helper'

class ItemTest < ActiveSupport::TestCase
   test "should not save item without title" do
     item = Item.new(:title => "")
     assert !item.save
   end
end
