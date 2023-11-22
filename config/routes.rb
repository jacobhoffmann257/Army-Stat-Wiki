Rails.application.routes.draw do
  resources :unit_abilities
  resources :abilities
  resources :profiles
  resources :equipment
  resources :weapons
  resources :units do
    resources :models
  end
  resources :factions

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get "/units/:unit_name" => "unit#show", as: :unit

  root "units#index"
end
