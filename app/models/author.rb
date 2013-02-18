class Author < ActiveRecord::Base
  has_many :items

  #attr_accessible :given_name, :surname, :id
  validate :surname, :presence => true, :uniqueness => {:scope => :given_name}
end
