class User < ActiveRecord::Base
  has_many :physical_items, :through => :rentals
  has_many :rentals
end
