namespace :build do

  desc "Create the contact scaffold"
  task :contact do
    system "rails g faalis:js_scaffold contact contact prefix:string first_name:string middle_name:string last_name:string suffix:string organization:string is_organization:boolean --bulk_fields organization,is_organization --tabs General:__all__,Extra"
  end
end
