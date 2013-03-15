require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "cannot save user without first name" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :category => 0, :email => "email@email.com")
    assert !user.save
  end

  test "cannot save user without last name" do
    user = User.new(:password => "aaabbbccc", :given_name => "doe", :category => 0, :email => "email@email.com")
    assert !user.save
  end

  test "cannot save user without category" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :email => "email@email.com")
    assert !user.save
  end

  test "cannot save user without email" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :category => 0)
    assert !user.save
  end

  test "cannot save user with category less than 0" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :email => "fake@fake.com", :category => -1)
    assert !user.save
  end

  test "cannot save user with category greater than 2" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :email => "fake@fake.com", :category => 2)
    assert !user.save
  end

  test "user with category 0 should be a patron" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :email => "fake@fake.com", :category => 0)
    assert user.category_as_string == "Patron"
  end

  test "user with category 1 should be a librarian" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :email => "fake@fake.com", :category => 1)
    assert user.category_as_string == "Librarian"
  end

  test "user with category 2 should be an admin" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :email => "fake@fake.com", :category => 2)
    assert user.category_as_string == "Admin"
  end

  test "cannot save duplicate users" do
    user = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :email => "fake@fake.com", :category => 2)
    user.save
    user2 = User.new(:password => "aaabbbccc", :surname => "doe", :given_name => "john", :email => "fake@fake.com", :category => 2)
    user2.save
    assert !user2.save
  end

  test "password must be greater than 5 characters long" do
    user = User.new(:password => "aaabc", :surname => "doe", :given_name => "john", :email => "fake@fake.com", :category => 2)
    assert !user.save
  end

  test "should accept valid email formats" do
    # valid format: text[at]text[dot]text
    u = User.new(:password => "aaabbbccc", :given_name => "John", :surname => "Doe", :category => 0, :email => "text@text.text")
    assert u.save!
    u2 = User.new(:password => "aaabbbccc", :given_name => "John", :surname => "Doe", :category => 0, :email => "text.text@text.text")
    assert u2.save!
    u3 = User.new(:password => "aaabbbccc", :given_name => "John", :surname => "Doe", :category => 0, :email => "TEXT@text.com")
    assert u3.save!
  end

  test "should not accept invalid email formats" do
    u = User.new(:password => "aaabbbccc", :given_name => "John", :surname => "Doe", :category => 0, :email => "TEXT@text@com")
    assert !u.save
  end
end
