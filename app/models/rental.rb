class Rental < ActiveRecord::Base
  attr_accessible :barcode_id, :renewals, :rent_date, :return_date, :user_id, :item_id
  
  belongs_to :user, :foreign_key => :user_id
  belongs_to :physical_item, :foreign_key => :barcode_id
  
#  # Add a error messgae??
#  validates_presence_of :barcode_id
#  validates_presence_of :renewals
#  validates_presence_of :rent_date
#  validates_presence_of :return_date
#  validates_presence_of :user_id
#  
#  # Add a scope??
#  validates_uniqueness_of :barcode_id
#  validates_uniqueness_of :user_id
  
end