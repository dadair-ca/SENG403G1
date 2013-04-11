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
  
  $stopwords = ["I", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what",  "when", "where", "who",  "will",  "with", "the", "www"]
  
  def self.levenshtein_search(search_terms, search_type)
    
    #Initalization of variables
    threshold = 10
    totaldl = 0
    lowestdl = -1
    
    
    wordCount = 0;  #Current word position pointer 
    letterPos = -1; #Letter position for a certain word in search_type for the current lowest Levenshtein value
    wordPos = -1;   #Word position within search_type for the current lowest Levenshtein value
    firstWPos = -1; #Stores the word position where the Levenshtein value equals to 0 (Match's)  
    firstLPos = -1; #Stores the letter position within the word where the Levenshtein value equals to 0 (Match's) 
    occurrence = 0; #Stores the number of times that a certain search_term match's to a search_type word.
    
    tempHash = Array.new;
    
    #Splitting search_type into a array
    search_db = search_type.to_s.downcase.strip
    search_db = search_db.gsub(/[^0-9A-Za-z ]/, '')
    search_db = search_db.split(' ').uniq
    
                                                                                      
    search_terms.each do |search_tok|                                                 #For each token in search terms
      st_len = search_tok.length                                                         
      search_db.each do |db_tok|                                                      #For each token in search_db
        wordCount+=1
        db_len = db_tok.length                                                          
        if (db_len > st_len)                                                          #If the length of db_tok is longer than search_tok
          for i in 0..(db_len-st_len)
            temp_db = db_tok[i..((st_len+i)-1)]
            temp_dl = DamerauLevenshtein.distance(temp_db, search_tok, 1, threshold)  #Obtain the Levenshtein value for that part of db_tok
            if((temp_dl < lowestdl) || (lowestdl == -1))                              
              wordPos = wordCount                                                     #Updating variables if they meet those criteria
              letterPos = i
              lowestdl = temp_dl
            elsif ((temp_dl == lowestdl) && (lowestdl > 0))                           #Also updating since if the lowest Levenstein value does not
              wordPos = wordCount                                                     #change, the values need to be updated in order to indicate
              letterPos = i                                                           #the word does not exist in search_db..
            end
            
            if(temp_dl == 0)                                                          #If a exact match is found between words
              occurrence-=1                                                          
              if(occurrence == -1)                                                    #If it is the first time that a exact match is found
                firstWPos = wordCount                                                 #Store the position from search_db
                firstLPos = i
              end
            end
          end
        
        else                                                                          #If the length of db_tok is less than or equal to search_tok,
          temp_dl = DamerauLevenshtein.distance(db_tok, search_tok, 1, threshold)     #do the same thing as above.
          letterPos = 0
          
          if((temp_dl < lowestdl) || (lowestdl == -1))
            wordPos = wordCount
            letterPos = db_tok.length                                                 #Notably if the Levenshtein value is greater than 0 then
            lowestdl = temp_dl                                                        #the letter position would be the length of db_tok, otherwise
          elsif ((temp_dl == lowestdl) && (lowestdl > 0))                             #letter position would be 0 if words do match.
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
      
      totaldl += lowestdl                                                             #Summing up all the sub Levenshtein values.
      
      
      if(occurrence > -1)                                                             #If no occurrence of search_tok exists in search_db,
        tempHash <<[:lowestdl, lowestdl]                                              #input these values into tempHash
        tempHash <<[:letPos, letterPos] 
        tempHash <<[:worPos, wordPos]
        tempHash <<[:occur, occurrence]
      else                                                                            #Otherwise,
        tempHash <<[:lowestdl, lowestdl]                                              #input these values into tempHash
        tempHash <<[:letPos, firstLPos] 
        tempHash <<[:worPos, firstWPos]
        tempHash <<[:occur, occurrence]
      end

      firstWPos = -1                                                                  #Reset all variables
      lowestdl = -1
      letterPos = -1
      wordPos = -1
      lowestdl = -1
      occurrence = 0
      wordCount = 0
    end
  
    tempHash << [:dlv, totaldl]                                                       #Once all the search_tok go through search_db, input the
    newHash = Hash[tempHash.map{|key, value| [key, value]}]                           #final total Levenshtein value into the array and change
                                                                                      #the array into a hash table.
    return newHash
    
  end
  
  def self.search(userinput)
    
    #Declaration of variables
    s_input = userinput[:search]
    s_type = userinput[:search_type]
    @patrons = User.find(:all)
    

    
    # apply search
    if(!s_input.nil?)
      
      u_input = s_input.to_s.downcase.strip
      u_input = u_input.gsub(/[^0-9A-Za-z ]/, '')
      u_input = u_input.split(' ').uniq
      u_input = u_input - $stopwords
      
      if(!u_input.blank?)
        result = Array.new
        threshold = u_input.length
        
        if s_type == "name"                                                # If the search_type is isbn10
          @patrons.each do |user|                                          # Find patrons that contain a Levenshtein value of less than
            patrons_name = user.given_name + user.surname                  # the threshold within the name section of patrons
            patronsRelevance = levenshtein_search(u_input, patrons_name)
            if(patronsRelevance[:dlv] <threshold)
              result << [user, patronsRelevance]
            end
          end
        elsif s_type == "email"                                            # If the search_type is email
          @patrons.each do |user|                                          # Find patrons that contain a Levenshtein value of less than
            patronsRelevance = levenshtein_search(u_input, user.email)     # the threshold within the emails section of patrons
            if(patronsRelevance[:dlv] <threshold)
              result << [user, patronsRelevance]
            end
          end
        elsif s_type == "userid"                                         # If the search_type is userid                                      
          @patrons.each do |user|                                        # Find patrons that contain a Levenshtein value of less than
            patronsRelevance = levenshtein_search(u_input, user.id)      # the threshold within the userid section of patrons
            if(patronsRelevance[:dlv] <1)
              result << [user, patronsRelevance]
            end
          end
          sort_result = Hash[result.map{|key, value| [key, value]}]       #How this sort works is described below
          sort_result = sort_result.sort_by{|k,v| [v[:dlv], v[:letPos], v[:lowestdl], k[:userid]]}
          sort_result = sort_result.map{|k,v| k}
          return sort_result
        end
        
        # Sort_result becomes a hash table for linking a patron to patronsRelevance
        #
        # Sort_result is then sorted by hash in the following order of importance: 
        # Levenshtein value
        # Word position of the lowest levenshtein value within the search area
        # Letter position of the previously mentioned word
        # Levenshtein for the particular search term
        # Number of occurrences of the search term within the search area
        # Given_name of patron
        # Surname of patron
        #
        # Sort_result now transforms into a array of sorted partons
        sort_result = Hash[result.map{|key, value| [key, value]}]
        sort_result = sort_result.sort_by{|k,v| [v[:dlv], v[:lowestdl], v[:letPos], v[:worPos], v[:occur], k[:given_name], k[:surname]]}
        sort_result = sort_result.map{|k,v| k}
        
        @patrons = sort_result
        
        return @patrons
      else
        @patrons = []  
            
        return @patrons
      end
    end
    
    if @patrons.nil?
      @patrons = []
    end
    
    return @patrons
    
  end
  
end




