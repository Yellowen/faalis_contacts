class Contact < ActiveRecord::Base
  include  Faalis::Concerns::Authorizable
  has_many :details, :class_name => "ContactDetails"
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  #validates_with ValueValidator

  def name
      "#{organization} - #{first_name} #{last_name}"

  end
end
