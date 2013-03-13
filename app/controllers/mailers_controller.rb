class MailersController < ApplicationController
  # GET /rental/1/mailers/overdue
  # GET /rental/1/mailers/overdue.json
  def new
    @id = params[:rental_id]
    if @id.nil?
      format.html { redirect_to rentals_path }
    else
      @rental = Rental.find(params[:rental_id])
      @user   = @rental.user
      @item   = @rental.item
      @mailer = Mailer.new()

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @mailer }
      end
    end
  end

  # POST /rental/1/mailers/
  # POST /rental/1/mailers/.json
  def create
    @method = params[:method]
    @rental = Rental.find(params[:rental])
    @mailer = Mailer.new(params[:mailer])

    respond_to do |format|
      if @method == "custom"
        if @mailer.valid?
          UserMailer.custom_email(@mailer, @rental).deliver
          format.html { redirect_to rentals_url, notice: 'Mail has been sent.' }
        else
          format.html { render :action => "new" }
          format.json { render json: @mailer.errors, status: :unprocessable_entity }
        end
      else
        UserMailer.overdue_email(@rental).deliver
        format.html { redirect_to rentals_url, notice: 'Mail has been sent.' }
      end
    end

  end

end
