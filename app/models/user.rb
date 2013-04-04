class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  has_many :physical_items, :through => :rentals
  has_many :rentals
  has_many :items, :through => :physical_items

  validates_presence_of :given_name
  validates_presence_of :surname
  validates_presence_of :category
  validates_presence_of :email

  validates_inclusion_of :category, :in => 0..2

  validates_uniqueness_of :email

  def category_as_string
    return "Patron" if self.category == 0
    return "Librarian" if self.category == 1
    return "Admin" if self.category == 2
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
  
  def self.search(userinput)
    # search params
    
    # start
    @patrons = Users

    # apply sorting
    
    
    # apply search
    idarray = userinput.to_s.strip.downcase.split(" ").uniq
    idarray = userinput - $stopwords

    if idarray.present?
      result = Array.new
      f_result = Array.new

      threshold = 3
      
      
      @books.each do |book|
        if((lev_value = levenshtein_search(words, book.title)) < threshold)
          result << [book, lev_value]
        end
      end
        
      
    
      result = result.sort_by(&:second)
      result.each{|r| f_result.push(r.first)}
      @books = f_result
        
    end
    
    if @books.nil?
      @books = []
    end
    
    return @books
    
  end
  
end
