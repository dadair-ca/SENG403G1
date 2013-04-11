class HoldsController < ApplicationController
  # GET /holds
  # GET /holds.json
  def index
    @holds = Hold.all
    @items = Item.all
    
    @holds.each do |h|
        if h.end_date < Date.today
            Hold.destroy(h)
        end    
    end  

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @holds }
    end
  end

  # GET /holds/1
  # GET /holds/1.json
  def show
    @hold = Hold.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @hold }
    end
  end

  # GET /holds/new
  # GET /holds/new.json
  # GET /user/1/holds/new
  # GET /user/1/holds/new.json
  def new
    @hold = Hold.new
    time = Time.now
    @hold.start_date = time
    time = time + 2.days
    @hold.end_date = time

    if !params[:item_id].nil?
        @item = Item.find(params[:item_id])
        @copies = @item.physical_items.all
        @copies.each do |c|
            if c.rental.nil? and c.hold.nil?
                @hold.barcode_id = c.barcode_id
            end
        end
    end 

    if !params[:user_id].nil?
      @user = User.find(params[:user_id])
      @hold.user_id = @user.id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @hold }   
    end
  end

  # GET /holds/1/edit
  def edit
    @hold = Hold.find(params[:id])
  end

  # POST /holds
  # POST /holds.json
  def create
    @hold = Hold.new(params[:hold])

    respond_to do |format|
      if @hold.save
        format.html { redirect_to @hold, :notice => 'Hold was successfully created.' }
        format.json { render :json => @hold, :status => :created, :location => @hold }
        
      elsif @hold.barcode_id.nil?
        format.html { render :action => "new" }
        format.json { render :json => @hold.errors, :status => :unprocessable_entity } 
      else
        format.html { render :action => "new" }
        format.json { render :json => @hold.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /holds/1
  # PUT /holds/1.json
  def update
    @hold = Hold.find(params[:id])

    respond_to do |format|
      if @hold.update_attributes(params[:hold])
        format.html { redirect_to @hold, :notice => 'Hold was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @hold.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /holds/1
  # DELETE /holds/1.json
  def destroy
    @hold = Hold.find(params[:id])
    @hold.destroy

    respond_to do |format|
      format.html { redirect_to holds_url }
      format.json { head :no_content }
    end
  end
end
