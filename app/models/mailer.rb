class Mailer < ActiveRecord::Base
  attr_accessible :email, :subject, :body

  validates_presence_of :email
  validates_presence_of :subject
  validates_presence_of :body
end
