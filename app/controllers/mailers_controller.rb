class MailersController < ApplicationController
  # GET /mailers
  # GET /mailers.json
  def index
    @mailers = Mailer.find(:all, :order => "id DESC", :limit => 20).reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mailers }
    end
  end

  # GET /mailers/1
  # GET /mailers/1.json
  def show
    @mailer = Mailer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mailer }
    end
  end

  # GET /mailers/1/new
  # GET /mailers/1/new.json
  def new
    @id     = params[:id]
    
    @rental = Rental.find(params[:id])
    @item   = Item.find(params[:id])
    @user   = Item.find(params[:id])
    @mailer = Mailer.new()

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mailer }
    end
  end

  # GET /mailers/1/edit
  def edit
    @mailer = Mailer.find(params[:id])
  end

  # POST /mailers
  # POST /mailers.json
  def create
    @method = params[:method]
    @rental = Rental.find(params[:rental])
    @item   = @rental.item
    @mailer = Mailer.new(params[:mailer])

    respond_to do |format|
      if @mailer.save
        if @method == "custom"
          UserMailer.custom_email(@mailer, @rental).deliver
        else
          UserMailer.overdue_email(@mailer, @rental).deliver
        end
        format.html { redirect_to rentals_url, notice: 'Mail has been sent.' }
      else
        format.html { render action: "new" }
        format.json { render json: @mailer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mailers/1
  # PUT /mailers/1.json
  def update
    @mailer = Mailer.find(params[:id])

    respond_to do |format|
      if @mailer.update_attributes(params[:mailer])
        format.html { redirect_to @mailer, notice: 'Mailer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mailer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mailers/1
  # DELETE /mailers/1.json
  def destroy
    @mailer = Mailer.find(params[:id])
    @mailer.destroy

    respond_to do |format|
      format.html { redirect_to mailers_url }
      format.json { head :no_content }
    end
  end
end
