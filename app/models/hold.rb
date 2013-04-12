class Hold < ActiveRecord::Base
  attr_accessible :barcode_id, :end_date, :start_date, :user_id
  
  
  has_one :item, :through => :physical_item
  belongs_to :user, :foreign_key => :user_id
  belongs_to :physical_item, :foreign_key => :barcode_id, :primary_key => :barcode_id

  validates_presence_of :user_id
  validates_presence_of :barcode_id, :message => 'No copies are avaliable to hold at this time. Please try again later.'
  validates_presence_of :start_date
  validates_presence_of :end_date

  validates_uniqueness_of :barcode_id
  
  validate :validate_user_id

private
  def validate_user_id
    if !User.exists?(self.user_id)
      errors.add(:user_id, "ID does not exist")
    end
  end

end
