require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "cannot save user without first name" do
    user = User.new(:surname => "doe", :category => 0, :email => "email@email.com")
    assert !user.save
  end
end
