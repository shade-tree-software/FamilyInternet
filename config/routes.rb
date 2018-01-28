Rails.application.routes.draw do

  root 'users#index'

  resources :users do
    member do
      get 'set'
    end
  end
  resources :info_messages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
