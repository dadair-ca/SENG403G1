class UserMailer < ActionMailer::Base
  default from: "noreply@weblib.shenafortozo.com"
  
  def custom_email(mail, rental)
    @mail   = mail
    @rental = rental
    #@user   = @rental.user
    mail(:to => "shena.fortozo@gmail.com", :subject => @mail.subject) #TODO@user
  end
  
  def overdue_email(mail, rental)
    @mail   = mail
    @rental = rental
    #@user   = @rental.user
    mail(:to => "shena.fortozo@gmail.com", :subject => "[WebLib] Overdue Item") #TODO@user
  end

end
