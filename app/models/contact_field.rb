class ContactField < ActiveRecord::Base
  validates :name, :presence => true
  validates :value_type, :presence => true
end
