Rails.application.routes.draw do
  resources :abilities
  resources :profiles
  resources :equipment
  resources :weapons
  resources :units
  resources :models
  resources :factions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
