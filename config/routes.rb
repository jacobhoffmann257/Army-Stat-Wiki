Rails.application.routes.draw do
  resources :tag_profiles
  resources :tags
  resources :profiles
  resources :equipment
  resources :weapons
  resources :models
  resources :units
  resources :factions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
