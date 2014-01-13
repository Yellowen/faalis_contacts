json.array! @contacts do |contact|
  json.extract! contact, :id, :prefix, :first_name, :middle_name, :last_name, :suffix, :organization, :is_organization
  json.details contact.details do |detail|
    json.id detail.id
    json.type detail.detail_type
    json.field detail.detail_field
    json.value detail.detail_value
  end
end
