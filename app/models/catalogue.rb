class Catalogue < ActiveRecord::Base
  $stopwords = ["I", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what",  "when", "where", "who",  "will",  "with", "the", "www"]

  def self.levenshtein_search(search_terms, search_type)
    
    #Initalization of variables
    threshold = 10
    totaldl = 0
    lowestdl = -1
    
    
    wordCount = 0;  #Current word position within search_type
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
              wordPos = wordCount                                                     #Updating variables if they meet the criteria
              letterPos = i
              lowestdl = temp_dl
            elsif ((temp_dl == lowestdl) && (lowestdl > 0))                           #Updating if the lowest Levenstein value does not
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
      
      
      if(occurrence > -1)                                                             #If no occurrence of search_tok exists in search_db
        tempHash <<[:lowestdl, lowestdl]                                              #Input these values into tempHash
        tempHash <<[:letPos, letterPos] 
        tempHash <<[:worPos, wordPos]
        tempHash <<[:occur, occurrence]
      else                                                                            #Otherwise
        tempHash <<[:lowestdl, lowestdl]                                              #Input these values into tempHash
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

  #Search all the items based upon the drop down menu selection
  #Note: I am using a bogus year value for the error message, which will
  #display nothing. Later on I'll remodify the view file for search
  #to handle errors.
  def self.search(sparams)
    # search params
    search_words = sparams[:search]
    search_type  = sparams[:search_type]
    
    # sorting params
    sort_col    = sparams[:sort_col]
    sort_dir    = sparams[:sort_dir]
  
    # filters params
    filter_type = sparams[:filter]
    filter_kind = sparams[:filter_kind]

    # start
    @books = Item.joins(:author)

    # apply filters
    if !filter_type.blank?
      filter_search = filter_kind.gsub('+',' ')
      if filter_type == 'given_name'
        @books = @books.where('given_name IN (?) AND surname IN (?)', filter_search.split(' '), filter_search.split(' '))
      else
        @books = @books.where(filter_type + ' LIKE ?', "%#{filter_search}%")
      end
    end

    # apply sorting
    if sort_col.present?
      @books = @books.order(sort_col + ' ' + sort_dir)
    end
    
    
    # apply search

    #Start of the catalogue search if there is anything enter into
    #the search textbox
    if(!search_words.nil?)
    
      #Creates an array from the user input
      words = search_words.to_s.downcase.strip
      words = words.gsub(/[^0-9A-Za-z ]/, '')
      words = words.split(' ').uniq
      words = words - $stopwords
      
      
      if(!words.blank?)                                                   #If the array is not blank
        result = Array.new
        threshold = words.length
        
        if search_type == 'title'                                         #If the search_type is title
          @books.find_each do |book|
            bookRelevance = levenshtein_search(words, book.title)
            if(bookRelevance[:dlv] <threshold)                            #If the Levenshtein value is less than the threshold
              result << [book, bookRelevance]                             #Input value into result
            end
          end
          
        elsif search_type == 'author'                                     #If the search_type is author
          @books.find_each do |book|
            authors_name = book.author.given_name + book.author.surname   #Concatenate first and last name
            bookRelevance = levenshtein_search(words, authors_name)       
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end                                                             #How this sort works is described below
          sort_result = Hash[result.map{|key, value| [key, value]}]       #Sort the results not by title, but by first and last name
          sort_result = sort_result.sort_by{|k,v| [v[:dlv], v[:lowestdl], v[:letPos], v[:worPos], v[:occur], k[:surname], k[:given_name]]}
          sort_result = sort_result.map{|k,v| k}
          return sort_result
        elsif search_type == 'genre'                                      #If the search_type is genre
          @books.find_each do |book|                                      #Find entries from books that contain a Levenshtein value of less than 
            bookRelevance = levenshtein_search(words, book.genre)         #the threshold within the genre section
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
        elsif search_type == 'publisher'                                  #If the search_type is publisher
          @books.find_each do |book|                                      #Find entries from books that contain a Levenshtein value of less than
            bookRelevance = levenshtein_search(words, book.publisher)     #the threshold within the publisher section
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
        elsif search_type == 'year'                                       #If the search_type is year
          @books.find_each do |book|                                      #Find entries from books that contain a Levenshtein value of less than
            bookRelevance = levenshtein_search(words, book.year)          #the threshold within the year section
            if(bookRelevance[:dlv] <1)
              result << [book, bookRelevance]
            end
          end
          sort_result = Hash[result.map{|key, value| [key, value]}]       #Sort the results not by title, but by year in descending
          sort_result = sort_result.sort_by{|k,v| [v[:dlv], k[:year], v[:lowestdl], v[:letPos], v[:worPos], v[:occur], k[:title]]}
          sort_result = sort_result.map{|k,v| k}
          return sort_result
        elsif search_type == 'isbn13'                                    #If the search_type is isbn13
          @books.find_each do |book|                                     #Find entries from books that contain a Levenshtein value of less than
            bookRelevance = levenshtein_search(words, book.isbn13)       #the threshold within the isbn13 section
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
        elsif search_type == 'isbn10'                                    #If the search_type is isbn10
          @books.find_each do |book|                                     #Find entries from books that contain a Levenshtein value of less than
            bookRelevance = levenshtein_search(words, book.isbn10)       #the threshold within the isbn10 section
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
        end
        
        # Sort_result becomes a hash table for linking a book to bookRelevance
        #
        # Sort_result is then sorted by hash in the following order of importance: 
        # Levenshtein value
        # Word position of the lowest levenshtein value within the search area
        # Letter position of the previously mentioned word
        # Levenshtein for the particular search term
        # Number of occurrences of the search term within the search area
        # Title of the book
        #
        # Sort_result now transforms into a array of sorted books
        sort_result = Hash[result.map{|key, value| [key, value]}]       
        sort_result = sort_result.sort_by{|k, v| [v[:dlv], v[:worPos], v[:letPos], v[:lowestdl], v[:occur], k[:title]]}
        sort_result = sort_result.map{|k,v| k}
        
        @books = sort_result

        return @books
        
      else
        @books = []  
          
        return @books
      end
    end
    
    
    if @books.nil?
      @books = []
    end
    
    return @books
    
  end
  
  def self.wordsdisplay(sparams)
    search_words = sparams[:search]
    words = search_words.to_s.split(' ')
    
    return words
  end
end
