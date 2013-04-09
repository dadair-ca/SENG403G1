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
    
    #Formatting data from database to be used in search
    search_db = search_type.to_s.downcase.strip.split(' ').uniq
    search_db = search_db.collect{|x| x.gsub( /\W/, ' ' )}
    search_db = search_db-$stopwords
    
    #For each word in search terms
    search_terms.each do |search_tok|
      if(search_db.include?(search_tok))
        lowestdl = 0
      else
        st_len = search_tok.length
        search_db.each do |db_tok|
          db_len = db_tok.length
          if (db_len > st_len)
            for i in 0..(db_len-st_len)
              temp_db = db_tok[i..((st_len+i)-1)]
              temp_dl = DamerauLevenshtein.distance(temp_db, search_tok, 1, threshold)
              if(temp_dl == 0)
                lowestdl = temp_dl
                break
              elsif((temp_dl < lowestdl) || (lowestdl == -1))
                lowestdl = temp_dl
              end
            end
          else
            lowestdl = DamerauLevenshtein.distance(db_tok, search_tok, 1, threshold)
          end
          
          if(lowestdl == 0)
            break
          end
        end
        totaldl += lowestdl
        lowestdl = -1
      end
    end 
    
    return totaldl 
    
          
  end
  
  def self.search(userinput)
    
    s_input = userinput[:search]
    s_type = userinput[:search_type]
    @patrons = User.find(:all)
    

    u_input = s_input.to_s.downcase.split(' ').uniq
    u_input = u_input.collect{|x| x.gsub( /\W/, ' ' )}
    u_input = u_input - $stopwords
    
    
      
    if u_input.present?
      result = Array.new
  
      threshold = 2
      
      if s_type == "name"      
        @patrons.each do |user|
          lev_fn = levenshtein_search(u_input, user.given_name)
          lev_ln = levenshtein_search(u_input, user.surname)
          
          if((lev_fn == 0) || (lev_ln == 0))
            lev_value = 0
          else
            lev_value = lev_fn + lev_ln
          end
          
          if(lev_value < threshold*2)
            result << [user, lev_value]
          end
        end
      elsif s_type == "email"
        @patrons.each do |user|
          if((lev_value = levenshtein_search(u_input, user.email)) < threshold)
            result << [user, lev_value]
          end
        end
      elsif s_type == "userid"
        @patrons.each do |user|
          if((lev_value = levenshtein_search(u_input, user.id)) < threshold)
            result << [user, lev_value]
          end
        end
      end
      
      result = result.sort_by{|x,y|y}
      result = result.map{|x,y| x}
      @patrons = result
      
    end
    
    
    if @patrons.nil?
      @patrons = []
    end
    
    return @patrons
    
  end
  
end
