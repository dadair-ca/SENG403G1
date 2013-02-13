class PhysicalItem < ActiveRecord::Base
  belongs_to :item
  attr_accessible :barcode_id
  validates :barcode_id, :uniqueness => true
  validates :barcode_id, :presence => true
end
