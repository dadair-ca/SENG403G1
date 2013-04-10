class MailersController < ApplicationController
  # GET /rental/1/mailers/overdue
  # GET /rental/1/mailers/overdue.json
  def overdue
    @id     = params[:id]
    @rental = Rental.find(params[:id])
    @user   = @rental.user
    @item   = @rental.item
    
    @mailer = Mailer.new()
    @mailer.subject = "[WebLib] Overdue Item"
    @mailer.body = 
"Hi #{@user.given_name} #{@user.surname},

The item '#{@item.title}' by #{@item.author.given_name} #{@item.author.surname} is overdue on #{@rental.return_date.strftime('%A, %B %d at %I:%M %p')}.

Thanks for using WebLib!"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @mailer }
    end
  end

  # POST /rental/1/mailers
  # POST /rental/1/mailers.json
  def create
    @method = params[:method]
    @rental = Rental.find(params[:rental])
    @mailer = Mailer.new(params[:mailer])

    respond_to do |format|
      if @mailer.valid?
        UserMailer.custom_email(@mailer, @rental).deliver
        format.html { redirect_to rentals_url, :notice => 'Mail has been sent.' }
      else
        format.html { render :action => "new" }
        format.json { render :json => @mailer.errors, :status => :unprocessable_entity }
      end
    end
  end
end
