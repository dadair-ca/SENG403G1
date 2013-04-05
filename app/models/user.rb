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
  
  def self.levenshtein_id(search_terms, search_id)
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
  
  def self.search(userinput)
    
    s_input = userinput[:search]
    s_type = userinput[:search_type]
    @patrons = User.find(:all)
    

    u_input = s_input.to_s.strip.downcase.split(" ").uniq
    u_input = u_input - $stopwords

    if u_input.present?
      result = Array.new
      f_result = Array.new
  
      threshold = 3
      
      if s_type == "name"      
        @patrons.each do |user|
          lev_value = levenshtein_search(u_input, user.given_name)
          lev_value += levenshtein_search(u_input, user.surname)
          if(lev_value < 6)
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
          if(user.id.to_s == u_input[0].to_s)
            lev_value = 0
            result << [user, lev_value]
          end
        end
      end
      
      result = result.sort_by(&:second)
      result.each{|r| f_result.push(r.first)}
      @patrons = f_result
      
    end
    
    if @patrons.nil?
      @patrons = []
    end
    
    return @patrons
    
  end
  
end
