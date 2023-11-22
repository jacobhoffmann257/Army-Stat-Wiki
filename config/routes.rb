Rails.application.routes.draw do
  
  resources :units do
    resources :models
    resources :equipment do
      resources :weapons do 
        resources :profiles
      end
    end
    resources :unit_abilities do 
      resources :abilities
    end
  end
  resources :factions

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get "/units/:unit_name" => "unit#show", as: :unit

  root "units#index"
end
