class Catalogue < ActiveRecord::Base
  $stopwords = ["I", "a", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what",  "when", "where", "who",  "will",  "with", "the", "www"]

  def self.levenshtein_search(search_terms, search_type)
    threshold = 10
    totaldl = 0
    lowestdl = -1
    
   
    search_db = search_type.to_s.downcase
    search_db = search_db.gsub(/[\W\d]+/, " ")
    search_db = search_db.split(" ").uniq
    search_db = search_db-$stopwords
    
    #For each word in search terms
    search_terms.each do |search_tok|
      if(search_db.include?(search_tok))
        lowestdl = 0
      else
        st_len = search_tok.length
        search_db.each do |db_tok|
          db_len = db_tok.length
          if (db_len >= st_len)
            for i in 0..(db_len-st_len)
              temp_db = db_tok[i..((st_len+i)-1)]
              temp_dl = DamerauLevenshtein.distance(temp_db, search_tok, 0, threshold)
              if(temp_dl == 0)
                lowestdl = temp_dl
                break
              elsif((temp_dl < lowestdl) || (lowestdl == -1))
                lowestdl = temp_dl
              end
            end
          else
            lowestdl = DamerauLevenshtein.distance(db_tok, search_tok, 0, threshold)
          end
        end
      end
      totaldl += lowestdl
      lowestdl = -1
    end 
    
    
    
    return totaldl  
    
          
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
    
    words = search_words.to_s.downcase.split(' ').uniq
    words = words.collect{|x| x.gsub(/(\W|\d)/, "")}
    words = words - $stopwords

    if words.present?
      eSearch = (Time.now.year + 1).to_s    #Bogue search variable
      result = Array.new
      f_result = Array.new

      threshold = 2
      isbn_threshold = 1
      
      if search_type == 'title'
        @books.each do |book|
          if((lev_value = levenshtein_search(words, book.title)) < threshold)
            result << [book, lev_value]
          end
        end
        
      elsif search_type == 'author'
        @books.each do |book|
          lev_value = levenshtein_search(words, book.author.given_name)
          lev_value += levenshtein_search(words, book.author.surname) 
          if(lev_value < threshold*2)
            result << [book, lev_value]
          end
        end
        
      elsif search_type == 'genre'
        @books.each do |book|
          if((lev_value = levenshtein_search(words, book.genre)) < threshold)
            result << [book, lev_value]
          end
        end
        
      elsif search_type == 'publisher'
        @books.each do |book|
          if((lev_value = levenshtein_search(words, book.publisher)) < threshold)
            result << [book, lev_value]
          end
        end
      
      elsif search_type == 'year' 
        if(words.length == 1 && (s_year = words[0].to_i) && (s_year <= Time.now.year))
          @books.each do |book|
            if(book.year == s_year)
              result << book
            end
          end
          result.sort_by(&:title)
        end
      
      elsif search_type == 'isbn13'
        @books.each do |book|
          if((lev_value = levenshtein_search(words, book.isbn13)) < isbn_threshold)
            result << [book, lev_value]
          end
        end
      
      elsif search_type == 'isbn10'
        @books.each do |book|
          if((lev_value = levenshtein_search(words, book.isbn10)) < isbn_threshold)
            result << [book, lev_value]
          end
        end
      end
   
      result.sort_by{|x,y|y}
      result.each{|r| f_result.push(r.first)}
      @books = f_result.sort{|x,y| y <=> x }
    end
    
    if @books.nil?
      @books = []
    end
    
    return @books
    
  end

end
