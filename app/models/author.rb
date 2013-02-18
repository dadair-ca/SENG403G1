class Author < ActiveRecord::Base
  has_many :items

  attr_accessible :given_name, :surname
end
