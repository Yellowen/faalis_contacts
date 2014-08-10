class ContactDetails < ActiveRecord::Base
    include  Faalis::Concerns::Authorizable
  @already_validate = false

  belongs_to :contact
  belongs_to :field, :class_name => "ContactField"

  validates :detail_field_id, :presence => true
  validates :detail_type, :presence => true
  validates :detail_value, :presence => true

  validate :validate_value


  def validate_value
    require 'json'
    if @already_validate
      return
    end


    if detail_field_id.nil?
      errors[:detail_field] = _("Field can not be empty.")
      return
    end
    rules = ContactField.find(detail_field_id).validation_rules
    params = JSON.parse(rules).deep_symbolize_keys
    @already_validate = true
    begin
      self.class.validates :detail_value, **params
    rescue ArgumentError => e
      errors[:error] = _("Field validation rules is not valid!")
    end
  end
end
