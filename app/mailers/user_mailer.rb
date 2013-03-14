class UserMailer < ActionMailer::Base
  default :from => "noreply@weblib.shenafortozo.com"
  
  def custom_email(mail, rental)
    @mail   = mail
    @rental = rental
    @user   = rental.user
    @item   = rental.item
    mail(:to => @user.email, :subject => @mail.subject)
  end
  
  def overdue_email(rental)
    @rental = rental
    @user   = rental.user
    @item   = rental.item
    mail(:to => @user.email, :subject => "[WebLib] Overdue Item")
  end

end
