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
    
		@authors    = Hash.new(0)
    @genres     = Hash.new(0)
		@years      = Hash.new(0)
		@publishers = Hash.new(0)
    
    @items.each do |i|
			authorname = i.author.given_name + ' ' + i.author.surname
      @authors[authorname] += 1
      @genres[i.genre] += 1
      @years[i.year] += 1
      @publishers[i.publisher] += 1
    end
    
    @years = @years.sort_by { |k,v| k }.sort_by { |k,v| -v }.first(8)
    @years = @years.sort_by { |k,v| k }.sort_by { |k,v| -v }.first(8)
    @years = @years.sort_by { |k,v| k }.sort_by { |k,v| -v }.first(8)
    @years = @years.sort_by { |k,v| k }.sort_by { |k,v| -v }.first(8)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @years }
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
