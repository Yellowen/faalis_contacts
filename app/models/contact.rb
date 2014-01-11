class Contact < ActiveRecord::Base
  has_many :contact_details

  validates :first_name, :presence => true
  validates :last_name, :presence => true
end
