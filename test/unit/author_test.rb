require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
    test "should not insert blank author" do
        author = Author.new
        assert !author.save
    end

   test "should not save duplicate authors" do
     author1 = Author.new(:given_name => "Mike", :surname => "Author")
     author1.save
     author2 = Author.new(:given_name => "Mike", :surname => "Author")
     assert !author2.save
   end

end
