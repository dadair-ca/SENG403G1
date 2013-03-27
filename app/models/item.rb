class Item < ActiveRecord::Base
  # Before saving an item record, run the method..
  before_save :replace_existing_author!

  has_many :physical_items, :dependent => :destroy
  belongs_to :author
  
  attr_accessible :title, :author_attributes, :year, :genre, :publisher, :isbn13, :isbn10

  validates_presence_of :title
  validates_presence_of :isbn13
  validates_presence_of :isbn10
  validates_presence_of :year
  validates_presence_of :publisher
  validates_presence_of :genre
  
  validates_uniqueness_of :title, :scope => [:isbn13, :isbn10, :year]
  validates_uniqueness_of :isbn13
  validates_uniqueness_of :isbn10
   
  
  validates :isbn13, :numericality => { :only_integer => true }
  validates :isbn10, :numericality => { :only_integer => true }
  validates :year, :numericality => { :only_integer => true }
  
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

  #Search all the items based upon the drop down menu selection
  #Note: I am using a bogus year value for the error message, which will
  #display nothing. Later on I'll remodify the view file for search
  #to handle errors.
  def self.search(search, search_type)
    eSearch = (Time.now.year + 1).to_s      #Bogue search variable
    search_str = search.to_s.gsub(/\s+/, ' ')    #Splits and concatenates search string, useful in getting rid of leading spaces.
    
    if search_str.present?
      if search_type != 'author'
        Item.joins(:author).find(:all, :conditions => [search_type + ' LIKE ?', "%#{search_str}%"])
      else
        Item.joins(:author).where('given_name LIKE ? or surname LIKE ?', "%#{search_str}%", "%#{search_str}%")
      end
    end
  end

#There are 3 things I can do to search for the authors name
#Call the author search method within the items controller
#Call the author search method within the view for search
#Figure out a way to get the author column to search in for this method

  def self.advance_search(title)
    find(:all, :conditions => ['title LIKE ?', "%#{title}%"]) # temporary/filler
  end
  
  
  
end
