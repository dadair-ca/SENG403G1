class RentalsController < ApplicationController
  before_filter :authenticate
  # GET /rentals
  # GET /rentals.json
  def index
    #@rentals = Rental.all
    if params[:sort].nil?
      params[:sort]      = "return_date"
      params[:direction] = "asc"
    end
    
    @rentals = Rental.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @rentals }
    end
  end

  # GET /rentals/1
  # GET /rentals/1.json
  def show
    @rental = Rental.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @rental }
    end
  end

  # GET /rentals/new
  # GET /rentals/new.json
  # GET /physical_item/1/rentals/new
  # GET /physical_item/1/rentals/new.json
  def new
    @rental = Rental.new
    @rental.renewals = 5

    time = Time.now
    @rental.rent_date = time
    time = time + 14.days
    @rental.return_date = time
    
    if !params[:physical_item_id].nil?    
      @physical_item = PhysicalItem.find(params[:physical_item_id])
      @rental.barcode_id = @physical_item.barcode_id
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @rental }
    end
    
    if !params[:physical_item_id].nil?    
      @physical_item = PhysicalItem.find(params[:physical_item_id])
      
      if !@physical_item.hold.nil?
        @physical_item.hold.destroy
      end
    end
  end

  # GET /rentals/1/edit
  def edit
    @rental = Rental.find(params[:id])
    @rental.renewals = @rental.renewals - 1
    time = @rental.return_date
    time = time + 14.days
    @rental.return_date = time
  end

  # POST /rentals
  # POST /rentals.json
  def create
    @rental = Rental.new(params[:rental])
    
    respond_to do |format|
      if @rental.save
        format.html { redirect_to @rental, :notice => 'Rental was successfully created.' }
        format.json { render :json => @rental, :status => :created, :location => @rental }
      else
        format.html { render :action => "new" }
        format.json { render :json => @rental.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rentals/1
  # PUT /rentals/1.json
  def update
    @rental = Rental.find(params[:id])

    respond_to do |format|
      if @rental.update_attributes(params[:rental])
        format.html { redirect_to @rental, :notice => 'Rental was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @rental.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rentals/1
  # DELETE /rentals/1.json
  def destroy
    @rental = Rental.find(params[:id])
    @rental.destroy

    respond_to do |format|
      format.html { redirect_to rentals_url }
      format.json { head :no_content }
    end
  end
  
  def authenticate
    redirect_to(new_user_session_path) unless user_signed_in?
  end

private
  def tableColumns
    Rental.column_names
  end

end
