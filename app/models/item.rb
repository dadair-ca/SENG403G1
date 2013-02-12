class Item < ActiveRecord::Base
  attr_accessible :title, :genre, :isbn13, :isbn10, :publisher, :year
end
