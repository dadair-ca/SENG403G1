class PhysicalItem < ActiveRecord::Base
  belongs_to :item
  attr_accessible :barcode_id
end
