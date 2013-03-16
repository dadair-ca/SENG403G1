class RentalsController < ApplicationController
  before_filter :authenticate
  # GET /rentals
  # GET /rentals.json
  def index

    @rentals = Rental.all

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
  def new
    if current_user.category > 0
        @rental = Rental.new
        @rental.renewals = 5

        respond_to do |format|
          format.html # new.html.erb
          format.json { render :json => @rental }
        end
    else
        redirect_to(rentals_path)
    end
  end
  
#  # GET /rentals/new/1
#  # GET /rentals/new.json
#  def new(i)
#    @rental = Rental.new
#    @rental.renewals = 5


#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render :json => @rental }
#    end
#  end

  # GET /rentals/1/edit
  def edit
    if current_user.category > 0
        @rental = Rental.find(params[:id])
        @rental.renewals = @rental.renewals - 1
    else
        redirect_to(rentals_path)
    end
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
  
end
