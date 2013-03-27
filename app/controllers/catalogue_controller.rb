class CatalogueController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  # GET /items
  # GET /items.json
  def index
    if params[:search].nil?
      @items = catalogueTable.find(:all, :order => sort_column + ' ' + sort_direction)
    else
      @items = Catalogue.search(params[:search], params[:search_type], sort_column, sort_direction)
    end
    
		@authors = {}
    @genres = {}
		@years = {}
		@publishers = {}
    
    @items.each do |i|
			authorname = i.author.given_name + ' ' + i.author.surname
      if(@authors.include? authorname)
        @authors[authorname] += 1
      else
				@authors[authorname] ||= 1
      end
			
      if(@genres.include? i.genre)
        @genres[i.genre] += 1
      else
				@genres[i.genre] ||= 1
      end
			
      if(@years.include? i.year)
        @years[i.year] += 1
      else
				@years[i.year] ||= 1
      end
			
      if(@publishers.include? i.publisher)
        @publishers[i.publisher] += 1
      else
				@publishers[i.publisher] ||= 1
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
    end
  end

private
  def catalogueTable
    Item.joins(:author)
  end

	def sort_column
	  catalogueTable.column_names.include?(params[:sort]) ? params[:sort] : "title"
	end
  
	def sort_direction
	  %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
	end

end
