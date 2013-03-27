class Catalogue < ActiveRecord::Base  

  #Search all the items based upon the drop down menu selection
  #Note: I am using a bogus year value for the error message, which will
  #display nothing. Later on I'll remodify the view file for search
  #to handle errors.
  def self.search(search, search_type, sort_col, sort_dir)
    eSearch = (Time.now.year + 1).to_s      #Bogue search variable
    search_str = search.to_s.gsub(/\s+/, ' ')    #Splits and concatenates search string, useful in getting rid of leading spaces.
    
    if search_str.present?
      if search_type != 'author'
        Item.joins(:author).find(:all, :conditions => [search_type + ' LIKE ?', "%#{search_str}%"])
      else
        Item.joins(:author).where('given_name LIKE ? or surname LIKE ?', "%#{search_str}%", "%#{search_str}%")
      end
    end
  end

end
