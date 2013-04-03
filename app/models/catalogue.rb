class Catalogue < ActiveRecord::Base
  $stopwords = ["I", "a", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what",  "when", "where", "who",  "will",  "with", "the", "www"]

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
    words = search_words.to_s.strip.downcase.split(" ").uniq
    words = words - $stopwords

    if words.present?
      eSearch = (Time.now.year + 1).to_s    #Bogue search variable
      result = Array.new
      f_result = Array.new

      threshold = 3
      
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
          if(lev_value < 6)
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
          if((lev_value = levenshtein_isbn(words, book.isbn13)) < threshold)
            result << [book, lev_value]
          end
        end
      
      elsif search_type == 'isbn10'
        @books.each do |book|
          if((lev_value = levenshtein_isbn(words, book.isbn10)) < threshold)
            result << [book, lev_value]
          end
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
