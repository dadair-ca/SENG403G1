class UserMailer < ActionMailer::Base
  default from: "noreply@weblib.shenafortozo.com"
  
  def custom_email(mail, rental, user, item)
    @mail   = mail
    @rental = rental
    @user   = user
    @item   = item
    mail(:to => "shena.fortozo@gmail.com", :subject => @mail.subject) #TODO@user
  end
  
  def overdue_email(rental, user, item)
    @rental = rental
    @user   = user
    @item   = item
    mail(:to => "shena.fortozo@gmail.com", :subject => "[WebLib] Overdue Item") #TODO@user
  end

end
