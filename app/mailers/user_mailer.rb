class UserMailer < ActionMailer::Base
  default from: "noreply@weblib.shenafortozo.com"
  
  def custom_email(mail, rental, user, item)
    @mail   = mail
    @rental = rental
    @user   = user
    @item   = item
    mail(:to => @user.email, :subject => @mail.subject)
  end
  
  def overdue_email(rental, user, item)
    @rental = rental
    @user   = user
    @item   = item
    mail(:to => @user.email, :subject => "[WebLib] Overdue Item")
  end

end
