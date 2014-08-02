class ContactField < ActiveRecord::Base
  include  Faalis::Concerns::Authorizable
  validates :name, :presence => true
  validates :value_type, :presence => true
end
