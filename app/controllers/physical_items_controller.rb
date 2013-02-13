class PhysicalItemsController < ApplicationController
  # This makes the load_item() function run before every other method
  before_filter :load_item

  # Show all physical items for the item
  def index
    @copies = @item.physical_items.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @copies }
    end
  end

  # Show the current physical item
  def show
    @copy = @item.physical_items.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @copy }
    end
  end

  def new
    @copy = @item.physical_items.new(params[:physical_item])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @copy }
    end
  end

  def create
    @copy = @item.physical_items.new(params[:physical_item])

    respond_to do |format|
      if @copy.save
        format.html { redirect_to [@item, @copy], :notice => 'Copy was successfully created.' }
        format.json { render :json => @copy, :status => :created, :location => @copy }
      else
        format.html { render :action => "new" }
        format.json { render :json => @copy.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  def edit
    @copy = @item.physical_items.find(params[:id])
  end

  def update
    @copy = @item.physical_items.find(params[:id])

    respond_to do |format|
      if @copy.update_attributes(params[:physical_item])
        format.html { redirect_to [@item, @copy], :notice => 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @copy.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
    def load_item
      @item = Item.find(params[:item_id])
    end
end
