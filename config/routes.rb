Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'employees#new'

  resources :employees, except: [:index] do
    member do
      get :confirm_email
      get :verify_phone_number
      post :confirm_phone_number
    end
  end
end
