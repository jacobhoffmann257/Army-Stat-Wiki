Rails.application.routes.draw do
  resources :unit_keywords
  resources :keywords
  resources :unit_abilities
  resources :abilities
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
  root "factions#index"
end
