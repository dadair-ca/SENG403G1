class MailersController < ApplicationController
  # GET /rental/1/mailers/overdue
  # GET /rental/1/mailers/overdue.json
  def overdue
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
      format.html # overdue.html.erb
      format.json { render :json => @mailer }
    end
  end

  # POST /mailers/overdue_create
  # POST /mailers/overdue_create.json
  def overdue_create
    @mailer = Mailer.new(params[:mailer])

    respond_to do |format|
      if @mailer.valid?
        UserMailer.custom_email(@mailer).deliver
        format.html { redirect_to rentals_url, :notice => 'Overdue notification has been sent.' }
      else
        @rental = Rental.find(params[:id])
        @user   = @rental.user
        @item   = @rental.item

        format.html { render :action => "overdue" }
        format.json { render :json => @mailer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /items/1/mailers/recall
  # GET /items/1/mailers/recall.json
  def recall
    @item  = Item.find(params[:id])
    @users = @item.users
    
    @mailer = Mailer.new()
    @mailer.subject = "[WebLib] Item Recall"
    @mailer.body = 
"Hi %patronName%,

The item '#{@item.title}' by #{@item.author.given_name} #{@item.author.surname} has been recalled. Please return the item as soon as possible.

Thanks for using WebLib!"

    respond_to do |format|
      format.html # recall.html.erb
      format.json { render :json => @mailer }
    end
  end

  # POST /mailers/recall_create
  # POST /mailers/recall_create.json
  def recall_create
    @item = Item.find(params[:id])
    @item.users.uniq.each do |patron|
      @mailer       = Mailer.new(params[:mailer])
      @mailer.email = patron.email
      @mailer.body  = @mailer.body.gsub('%patronName%', patron.given_name + ' ' + patron.surname)
      if @mailer.valid?
        UserMailer.custom_email(@mailer).deliver
      end
    end

    respond_to do |format|
      format.html { redirect_to @item, :notice => 'Item recall notification has been sent.' }
    end
  end
end
