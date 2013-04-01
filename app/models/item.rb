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
  
  validates :year, :numericality => { :only_integer => true }
  
  accepts_nested_attributes_for :author
  
  $stopwords = ["I", "a", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what",  "when", "where", "who",  "will",  "with", "the", "www"]
  
  # Try to find an existing author rather than creating a duplicate record
  # If one if found, grab the reference.
  def replace_existing_author!
    if self.author
      author = Author.where(:given_name => self.author.given_name,
                            :surname => self.author.surname).first
      self.author = author if author 
    end
  end
  
  def self.levenshtein_search(search_terms, search_type)
    
    threshold = 2
    totaldl = 0
    lowestdl = -1
    
    tok_db = search_type.to_s.strip.downcase.split(" ").uniq
    tok_db = tok_db - $stopwords
    tok_st = search_terms
    
    tok_st.each do |search_tok|
      tok_db.each do |db_tok|
        temp = DamerauLevenshtein.distance(db_tok, search_tok, 1, threshold)
        if(temp == 0)
          lowestdl = temp
        elsif((temp < lowestdl) || (lowestdl == -1))
          lowestdl = temp
        end
      end
      totaldl += lowestdl
    end
    
    return totaldl
      
  end
  
  def self.levenshtein_isbn(search_terms, search_isbn)
  
    tok_db = search_isbn.to_s.strip.downcase
    tok_st = search_terms[0]
    
    threshold = 2
    totaldl = 0
    lowestdl = -1
    
    db_len = tok_db.length
    st_len = tok_st.length
    
    if db_len < st_len
      return 3
    else
      for i in 0..(db_len-st_len-1)
        temp_db = tok_db[i..(st_len+i)]
        temp_dl = DamerauLevenshtein.distance(temp_db, tok_st, 1, threshold)
        if(temp_dl == 0)
          lowestdl = temp_dl
        elsif((temp_dl < lowestdl) || (lowestdl == -1))
          lowestdl = temp_dl
        end
      end
    end
    
    return lowestdl
  end

  #Search all the items based upon the drop down menu selection
  #Note: I am using a bogus year value for the error message, which will
  #display nothing. Later on I'll remodify the view file for search
  #to handle errors.
  def self.search(search, search_type, id_list)
    eSearch = (Time.now.year + 1).to_s    #Bogue search variable
    words = search.to_s.strip.downcase.split(" ").uniq
    words = words - $stopwords
    
    threshold = 3
    @books = self.joins(:author)
    result = Array.new
    f_result = Array.new
    
    if words.present?
      if search_type == 'Title'
        @books.each do |book|
          if((lev_value = levenshtein_search(words, book.title)) < threshold)
            result << [book, lev_value]
          end
        end
        
      elsif search_type == 'Author'
        @books.each do |book|
          lev_value = levenshtein_search(words, book.author.given_name)
          lev_value += levenshtein_search(words, book.author.surname) 
          if(lev_value < 6)
            result << [book, lev_value]
          end
        end
        
      elsif search_type == 'Genre'
        @books.each do |book|
          if((lev_value = levenshtein_search(words, book.genre)) < threshold)
            result << [book, lev_value]
          end
        end
        
      elsif search_type == 'Publisher'
        @books.each do |book|
          if((lev_value = levenshtein_search(words, book.publisher)) < threshold)
            result << [book, lev_value]
          end
        end
      elsif search_type == 'Year' 
        if(words.length == 1)
          if((words[0].to_i) && (words[0].to_i <= Time.now.year))
            s_year = words[0].to_i
            @books.each do |book|
              if(book.year == s_year)
                result << book
              end
            end
            result.sort_by(&:title)
            return result
          end
        end
      elsif search_type == 'ISBN 13'
        @books.each do |book|
          if((lev_value = levenshtein_isbn(words, book.isbn13)) < threshold)
            result << [book, lev_value]
          end
        end
      elsif search_type == 'ISBN 10'
        @books.each do |book|
          if((lev_value = levenshtein_isbn(words, book.isbn10)) < threshold)
            result << [book, lev_value]
          end
        end
      end
   
      result.sort_by(&:second)
      result.each{|r| f_result.push(r[0])}
      return f_result
      
    else
      return result
    end
    
    
  end
  
  def self.view(search, search_type, id_list)
      return(search.to_s.strip.split(" ").uniq)
  end

#There are 3 things I can do to search for the authors name
#Call the author search method within the items controller
#Call the author search method within the view for search
#Figure out a way to get the author column to search in for this method

  def self.advance_search(title)
    @books.each do |book|
      if((lev_value = levenshtein_search(words, book.title)) < 3)
        result << [book, lev_value]
      end
    end
    
    result.sort_by(&:last)
    result.map {|r| r[0]}

    return result
  end

end
