Rails.application.routes.draw do
  resources :models
  resources :units
  resources :factions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
