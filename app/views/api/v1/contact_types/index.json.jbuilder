json.array! @contact_types do |contact_type|
  json.extract! contact_type, :id, :name
end
