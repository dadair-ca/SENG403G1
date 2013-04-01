class Catalogue < ActiveRecord::Base  
  def self.search(sparams)
    # search
    search_kind = sparams[:search]
    search_type = sparams[:search_type]
    
    # sorting
    sort_col    = sparams[:sort_col]
    sort_dir    = sparams[:sort_dir]
  
    # filters
    filter_type = sparams[:filter]
    filter_kind = sparams[:filter_kind]
    
    eSearch = (Time.now.year + 1).to_s             #Bogue search variable
    search_str = search_kind.to_s.gsub(/\s+/, ' ') #Splits and concatenates search string, useful in getting rid of leading spaces.
    
    query = Item.joins(:author)
    
    if search_str.present?
      if search_type == 'given_name'
        query = query.where('given_name LIKE ? or surname LIKE ?', "%#{search_str}%", "%#{search_str}%")
      else
        query = query.where(search_type + ' LIKE ?', "%#{search_str}%")
      end
    end
    
    if !filter_type.blank?
      filter_search = filter_kind.gsub('+',' ')
      if filter_type == 'given_name'
        query = query.where('given_name IN (?) AND surname IN (?)', filter_search.split(' '), filter_search.split(' '))
      else
        query = query.where(filter_type + ' LIKE ?', "%#{filter_search}%")
      end
    end
    
    if sort_col.present?
      query = query.order(sort_col + ' ' + sort_dir)
    end
    
  end

end
