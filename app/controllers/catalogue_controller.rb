class CatalogueController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  # GET /items
  # GET /items.json
  def index
    @items = catalogueTable.order(sort_column + ' ' + sort_direction)
	
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
