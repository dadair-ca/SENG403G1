class PhysicalItem < ActiveRecord::Base
  belongs_to :item
  has_one :users, :through => :rentals
  has_one :rentals, :foreign_key => :barcode_id, :primary_key => :barcode_id

  attr_accessible :barcode_id, :item_id
  validates :barcode_id, :uniqueness => true
  validates :barcode_id, :presence => true
  validates :barcode_id, :numericality => { :only_integer => true }
end


def self.search(search)
  if search
    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  else
    find(:all)
  end
end
