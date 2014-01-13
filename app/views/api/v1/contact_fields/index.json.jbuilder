json.array! @contact_fields do |contact_field|
  json.extract! contact_field, :id, :name
end
