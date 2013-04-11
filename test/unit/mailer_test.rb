require 'test_helper'

class MailerTest < ActiveSupport::TestCase
  def setup
    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end
  
  test "mail should be sent successfully" do
    user = User.create(:password => "aaabbbccc", :surname => "doe", :category => 0, :email => "email@email.com")
    
    mailer = Mailer.new()
    mailer.email = user.email
    mailer.subject = "[WebLib] Mailer Test"
    mailer.body = "Thanks for using WebLib!"
   
    assert mailer.valid?

    UserMailer.custom_email(mailer).deliver    
    assert !@emails.empty?
  end

  test "mail should not send with an empty email field" do
    mailer = Mailer.new()
    mailer.subject = "[WebLib] Mailer Test"
    mailer.body = "Thanks for using WebLib!"
   
    assert_false mailer.valid?

    UserMailer.custom_email(mailer).deliver
    assert @emails.empty?
  end

  test "mail should not send with an empty subject field" do
    user = User.create(:password => "aaabbbccc", :surname => "doe", :category => 0, :email => "email@email.com")
    
    mailer = Mailer.new()
    mailer.email = user.email
    mailer.body = "Thanks for using WebLib!"
   
    assert_false mailer.valid?

    UserMailer.custom_email(mailer).deliver
    assert @emails.empty?
  end

  test "mail should not send with an empty body field" do
    user = User.create(:password => "aaabbbccc", :surname => "doe", :category => 0, :email => "email@email.com")
    
    mailer = Mailer.new()
    mailer.email = user.email
    mailer.subject = "[WebLib] Mailer Test"
   
    assert_false mailer.valid?
    
    UserMailer.custom_email(mailer).deliver    
    assert @emails.empty?
  end

end
