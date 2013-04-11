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
  
  $stopwords = ["I", "a", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what",  "when", "where", "who",  "will",  "with", "the", "www"]
  
  def self.levenshtein_search(search_terms, search_type)
    threshold = 10
    totaldl = 0
    lowestdl = -1
    
    
    wordCount = -1;
    letterPos = -1;
    wordPos = -1;
    firstWPos = -1;
    firstLPos = -1;
    occurrence = 0;
    
    tempHash = Array.new;
    
    search_db = search_type.to_s.downcase.strip
    search_db = search_db.gsub(/[^0-9A-Za-z ]/, '')
    search_db = search_db.split(' ').uniq
    search_db = search_db - $stopwords
    
    
    #For each word in search terms
    search_terms.each do |search_tok|
      st_len = search_tok.length
      
      search_db.each do |db_tok|
        wordCount+=1
        db_len = db_tok.length
        if (db_len > st_len)
          for i in 0..(db_len-st_len)
            temp_db = db_tok[i..((st_len+i)-1)]
            temp_dl = DamerauLevenshtein.distance(temp_db, search_tok, 1, threshold)
            if((temp_dl < lowestdl) || (lowestdl == -1))
              wordPos = wordCount
              letterPos = i
              lowestdl = temp_dl
            elsif ((temp_dl == lowestdl) && (lowestdl > 0))
              wordPos = wordCount
              letterPos = i
            end
            
            if(temp_dl == 0)
              occurrence-=1
              if(occurrence == -1)
                firstWPos = wordCount
                firstLPos = i
              end
            end
          end
        else
          temp_dl = DamerauLevenshtein.distance(db_tok, search_tok, 1, threshold)
          letterPos = 0
          
          if((temp_dl < lowestdl) || (lowestdl == -1))
            wordPos = wordCount
            letterPos = i
            lowestdl = temp_dl
          elsif ((temp_dl == lowestdl) && (lowestdl > 0))
            wordPos = wordCount
          end
          
          if(temp_dl == 0)
            occurrence-=1
            if(occurrence == -1)
              firstWPos = wordCount
              firstLPos = 0
            end
          end
          
        end 
      end
      
      totaldl += lowestdl
      
      
      if(firstWPos == -1)
        tempHash <<[:lowestdl, lowestdl]
        tempHash <<[:letPos, letterPos] 
        tempHash <<[:worPos, wordPos]
        tempHash <<[:occur, occurrence]
      else
        tempHash <<[:lowestdl, lowestdl]
        tempHash <<[:letPos, firstLPos] 
        tempHash <<[:worPos, firstWPos]
        tempHash <<[:occur, occurrence]
      end

      firstWPos = -1
      lowestdl = -1
      letterPos = -1
      wordPos = -1
      lowestdl = -1
      occurrence = 0
      wordCount = -1
    end
  
    tempHash << [:dlv, totaldl]
    newHash = Hash[tempHash.map{|key, value| [key, value]}]
    
    return newHash
    
  end
  
  def self.search(userinput)
    
    s_input = userinput[:search]
    s_type = userinput[:search_type]
    @patrons = User.find(:all)
    
    u_input = s_input.to_s.downcase.strip
    u_input = u_input.gsub(/[^0-9A-Za-z ]/, '')
    u_input = u_input.split(' ').uniq
    u_input = u_input - $stopwords
    
    if u_input.present?
      result = Array.new
  
      threshold = u_input.length
      
      if s_type == "name"      
        @patrons.each do |user|
          patrons_name = user.given_name + user.surname
          patronsRelevance = levenshtein_search(u_input, patrons_name)
          if(patronsRelevance[:dlv] <threshold)
            result << [user, patronsRelevance]
          end
        end
      elsif s_type == "email"
        @patrons.each do |user|
          patronsRelevance = levenshtein_search(u_input, user.email)
          if(patronsRelevance[:dlv] <threshold)
            result << [user, patronsRelevance]
          end
        end
      elsif s_type == "userid"
        @patrons.each do |user|
          patronsRelevance = levenshtein_search(u_input, user.id)
          if(patronsRelevance[:dlv] <threshold)
            result << [user, patronsRelevance]
          end
        end
        sort_result = Hash[result.map{|key, value| [key, value]}]
        sort_result = sort_result.sort_by{|k,v| [v[:dlv], v[:occur], v[:lowestdl], k[:given_name]]}
        sort_result = sort_result.map{|k,v| k}
        return sort_result
      end
      
      sort_result = Hash[result.map{|key, value| [key, value]}]
      sort_result = sort_result.sort_by{|k,v| [v[:dlv], v[:lowestdl], v[:letPos], v[:worPos], v[:occur], k[:given_name], k[:surname]]}
      sort_result = sort_result.map{|k,v| k}
      return sort_result
      
    end
    
    
    if @patrons.nil?
      @patrons = []
    end
    
    return @patrons
    
  end
  
end

