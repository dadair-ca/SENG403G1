class UserMailer < ActionMailer::Base
  default :from => "noreply@weblib.shenafortozo.com"
  
  def custom_email(mail)
    @mail = mail
    mail(:to => @mail.email, :subject => @mail.subject)
  end

end
