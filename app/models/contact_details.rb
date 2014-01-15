class ContactDetails < ActiveRecord::Base
  belongs_to :contact
  belongs_to :field, :class_name => "ContactField"

  validates :detail_field_id, :presence => true
  validates :detail_type, :presence => true
  validates :detail_value, :presence => true

  validate :validate_value


  def validate_value
    require 'json'
    rules = ContactField.find(detail_field_id).validation_rules
    params = JSON.parse(rules).deep_symbolize_keys
    begin
      self.class.validates :detail_value, **params
    rescue ArgumentError => e
      errors[:error] = _("Field validation rules is not valid!")
    end
  end
end
