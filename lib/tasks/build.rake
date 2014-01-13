namespace :build do

  desc "Create the contact scaffold"
  task :contact do
    system "rails g faalis:js_scaffold contact prefix:string first_name:string middle_name:string last_name:string suffix:string organization:string is_organization:boolean --bulk_fields organization,is_organization --tabs General:__all__,Extra,Avatar"
  end

  desc "Create contact fields scaffold"
  task :fields do
    system "rails g faalis:js_scaffold contact_field name:string --no-bulk --required name"
  end

  desc "Create contact type scaffold"
  task :types do
    system "rails g faalis:js_scaffold contact_type name:string --no-bulk --required name"
  end

end
