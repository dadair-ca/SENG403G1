class Author < ActiveRecord::Base
  has_many :authoreds
  has_many :items, :through => :authoreds

  attr_accessible :given_name, :surname
end
