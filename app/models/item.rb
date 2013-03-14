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
                            
    eSearch = (Time.now.year + 1).to_s    #Bogue search variable
    search_str = search.gsub(/\s+/, ' ')    #Splits and concatenates search string, useful in getting rid of leading spaces.
    
    Item.joins(:author)
    
    if search_str.present?
      if search_type == 'Title'
        find(:all, :conditions => ['title LIKE ?', "%#{search_str}%"])
      elsif search_type == 'Author'
        search_str.scan(/[[:alpha:]]+/).each do |name|
          find(:all, :conditions => [' author.surname LIKE ?', "%#{name}%"])
        end
      elsif search_type == 'Genre'
        find(:all, :conditions => ['genre LIKE ?', "%#{search_str}%"])
      elsif search_type == 'Publisher'
        find(:all, :conditions => ['publisher LIKE ?', "%#{search_str}%"])
      elsif search_type == 'Year'
        if((search.to_i) && (search.to_i <= Time.now.year))
          find(:all, :conditions => ['year LIKE ?', "%#{search_str}%"])
        else
          find(:all, :conditions => ['year LIKE ?', "%#{eSearch}%"])
        end
      elsif search_type == 'ISBN 13'
        find(:all, :conditions => ['isbn13 EXACT ?', "%#{search_str}%"])
      elsif search_type == 'ISBN 10'
        find(:all, :conditions => ['isbn10 EXACT ?', "%#{search_str}%"])
      else
        find(:all, :conditions => ['year LIKE ?', "%#{eSearch}%"])
      end
    else
      find(:all, :conditions => ['year LIKE ?', "%#{eSearch}%"])
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
