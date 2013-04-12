class UserMailer < ActionMailer::Base
  default :from => "noreply@weblib.shenafortozo.com"
  
  def custom_email(mail)
    @mail = mail
    mail(:to => @mail.email, :subject => @mail.subject)
  end

  def holdNotice_email(hold)
    @hold = hold
    @user = @hold.user
    @item = @hold.item
    
    mail(:to => @user.email, :subject => "[WebLib] Hold Notice")
  end

end
