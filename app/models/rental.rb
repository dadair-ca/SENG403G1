class Rental < ActiveRecord::Base
  attr_accessible :barcode_id, :renewals, :rent_date, :return_date, :user_id
end
