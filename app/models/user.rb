class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  has_many :physical_items, :through => :rentals
  has_many :rentals

  validates_presence_of :given_name
  validates_presence_of :surname
  validates_presence_of :category
  validates_presence_of :email

  validates_uniqueness_of :email

  def category_as_string
    return "Patron" if self.category == 0
    return "Librarian" if self.category == 1
    return "Admin" if self.category == 2
  end
end
