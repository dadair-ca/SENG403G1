class HoldsController < ApplicationController
  # GET /holds
  # GET /holds.json
  def index
    @holds = Hold.all

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
  def new
    @hold = Hold.new

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
