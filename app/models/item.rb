class Item < ActiveRecord::Base
  has_many :physical_items, :dependent => :destroy

  attr_accessible :title, :genre, :isbn13, :isbn10, :publisher, :year

  validates :title,  :presence => true
  validates :isbn13, :presence => true, :uniqueness => true
  validates :isbn10, :presence => true, :uniqueness => true
end
