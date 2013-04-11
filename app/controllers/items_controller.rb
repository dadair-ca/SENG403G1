class ItemsController < ApplicationController
  before_filter :authenticate, :except => [ :show, :index ]

  # GET /items
  # GET /items.json
  def index
    @items = Item.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @copies = @item.physical_items.all
    @author = @item.author

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new    
    if current_user.category > 0
        @item = Item.new
        @item.build_author

        respond_to do |format|
            format.html # new.html.erb
            format.json { render :json => @item }
        end
    else
        redirect_to(items_path)
    end
  end

  # GET /items/1/edit
  def edit
    if current_user.category > 0
        @item = Item.find(params[:id])
    else
        redirect_to(items_path)
    end
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.create(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, :notice => 'Item was successfully created.' }
        format.json { render :json => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, :notice => 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
  
  def authenticate
    redirect_to(new_user_session_path) unless user_signed_in?
  end
  
end
