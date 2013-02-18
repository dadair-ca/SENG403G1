class Item < ActiveRecord::Base
  # Before saving an item record, run the method..
  before_save :replace_existing_author!

  has_many :physical_items, :dependent => :destroy

  belongs_to :author

  #attr_accessible :title, :genre, :isbn13, :isbn10, :publisher, :year
  #attr_accessible :author_id

  validates :title,  :presence => true
  validates :isbn13, :presence => true
  validates :isbn10, :presence => true

  accepts_nested_attributes_for :author

  # Try to find an existing author rather than creating a duplicate record
  # If one if found, grab the reference.
  def replace_existing_author!
    if self.author
      author = Author.where(:given_name => self.author.given_name,
                            :surname => self.author.surname).first
      self.author = author if author 
    end
  end
end
