class Hold < ActiveRecord::Base
  attr_accessible :barcode_id, :end_date, :start_date, :user_id
end
