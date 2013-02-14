class Authored < ActiveRecord::Base
  belongs_to :item
  belongs_to :author
  attr_accessible :author_id, :item_id
end
