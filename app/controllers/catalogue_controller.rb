class CatalogueController < ApplicationController
  helper_method :sort_column, :sort_direction, :filter_type
  
  $stopwords = ["I", "a", "about", "an", "are", "as", "at", "be", "by", "com", "for", "from", "how", "in", "is", "it", "of", "on", "or", "that", "the", "this", "to", "was", "what",  "when", "where", "who",  "will",  "with", "the", "www"]

  # GET /items
  # GET /items.json
  def index
    sparams = params.merge({ :sort_col => sort_column, :sort_dir => sort_direction, :filter => filter_type })
    @items = Catalogue.search(sparams)
    
		@authors    = Hash.new(0)
    @genres     = Hash.new(0)
		@years      = Hash.new(0)
		@publishers = Hash.new(0)
    
    @items.each do |i|
			authorname = i.author.given_name + ' ' + i.author.surname
      @authors[authorname]     += 1
      @genres[i.genre]         += 1
      @years[i.year]           += 1
      @publishers[i.publisher] += 1
    end
    
    @authors    = @authors.sort_by { |k,v| k }.sort_by { |k,v| -v }.first(8)
    @genres     = @genres.sort_by { |k,v| k }.sort_by { |k,v| -v }.first(8)
    @years      = @years.sort_by { |k,v| k }.sort_by { |k,v| -v }.first(8)
    @publishers = @publishers.sort_by { |k,v| k }.sort_by { |k,v| -v }.first(8)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
    end
  end

private
  def catalogueColumns
    Item.column_names + Author.column_names
  end

	def sort_column
	  catalogueColumns.include?(params[:sort]) ? params[:sort] : "title"
	end
  
	def sort_direction
	  %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
	end
  
  def filter_type
    catalogueColumns.include?(params[:filter_type]) ? params[:filter_type] : nil
  end

end
