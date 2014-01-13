Rails.application.routes.draw do
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :contacts, :except => [:new]
      resources :contact_types, :except => [:new]
      resources :contact_fields, :except => [:new]
    end
  end
end
