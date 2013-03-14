class Rental < ActiveRecord::Base
  attr_accessible :barcode_id, :renewals, :rent_date, :return_date, :user_id, :item_id
  
  has_one :item, :through => :physical_item
  belongs_to :user, :foreign_key => :user_id
  belongs_to :physical_item, :foreign_key => :barcode_id, :primary_key => :barcode_id
  has_one :item, :through => :physical_item
  
#  # Add a error messgae??
  validates_presence_of :barcode_id
  validates_presence_of :renewals
  validates_presence_of :rent_date
  validates_presence_of :return_date
  validates_presence_of :user_id
#  validates_presence_of :item_id
 
#  # Add a scope??
#  validates_uniqueness_of :barcode_id
#  validates_uniqueness_of :user_id
  
end
