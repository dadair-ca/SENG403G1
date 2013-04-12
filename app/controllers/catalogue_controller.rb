require 'will_paginate/array'

class CatalogueController < ApplicationController
  # GET /items
  # GET /items.json
  def index
    @items = Catalogue.search(params.merge({
                  :sort_col => sort_column,
                  :sort_dir => sort_direction,
                  :filter   => filter_type }))
    
    @words = Catalogue.wordsdisplay(params.merge({
                  :sort_col => sort_column,
                  :sort_dir => sort_direction,
                  :filter   => filter_type }))
                  
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

    @results = @items.size
    
    @items = @items.paginate(:per_page => params[:per_page], :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
    end
  end

private
  def tableColumns
    Item.column_names + Author.column_names
  end

end
