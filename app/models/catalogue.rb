class Catalogue < ActiveRecord::Base
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
      
      if(!words.blank?)
        result = Array.new
        threshold = words.length
        
        if search_type == 'title'
          @books.find_each do |book|
            bookRelevance = levenshtein_search(words, book.title)
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
          
        elsif search_type == 'author'
          @books.find_each do |book|
            authors_name = book.author.given_name + book.author.surname
            bookRelevance = levenshtein_search(words, authors_name)
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
          sort_result = Hash[result.map{|key, value| [key, value]}]
          sort_result = sort_result.sort_by{|k,v| [v[:dlv], v[:lowestdl], v[:letPos], v[:worPos], v[:occur], k[:surname], k[:given_name]]}
          sort_result = sort_result.map{|k,v| k}
          return sort_result
        elsif search_type == 'genre'
          @books.find_each do |book|
            bookRelevance = levenshtein_search(words, book.genre)
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
        elsif search_type == 'publisher'
          @books.find_each do |book|
            bookRelevance = levenshtein_search(words, book.publisher)
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
        elsif search_type == 'year' 
          if(words.length == 1 && (s_year = words[0].to_i) && (s_year <= Time.now.year))
            @books.find_each do |book|
              bookRelevance = levenshtein_search(words, book.year)
              if(bookRelevance[:dlv] <1)
                result << [book, bookRelevance]
              end
            end
            sort_result = Hash[result.map{|key, value| [key, value]}]
            sort_result = sort_result.sort_by{|k,v| [v[:dlv], k[:year], v[:lowestdl], v[:letPos], v[:worPos], v[:occur], k[:title]]}
            sort_result = sort_result.map{|k,v| k}
            return sort_result
          end
        elsif search_type == 'isbn13'
          @books.find_each do |book|
            bookRelevance = levenshtein_search(words, book.isbn13)
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
        elsif search_type == 'isbn10'
          @books.find_each do |book|
            bookRelevance = levenshtein_search(words, book.isbn10)
            if(bookRelevance[:dlv] <threshold)
              result << [book, bookRelevance]
            end
          end
        end
        
        sort_result = Hash[result.map{|key, value| [key, value]}]
        sort_result = sort_result.sort_by{|k,v| [v[:dlv], v[:lowestdl], v[:worPos], v[:letPos], v[:occur], k[:title]]}
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
