json.array! @contacts do |contact|
  json.extract! contact, :id, :prefix, :first_name, :middle_name, :last_name, :suffix, :organization, :is_organization
end
