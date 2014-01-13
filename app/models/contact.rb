class Contact < ActiveRecord::Base
  has_many :details, :class_name => "ContactDetails"

  validates :first_name, :presence => true
  validates :last_name, :presence => true
end
