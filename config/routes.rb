Rails.application.routes.draw do
  devise_for :users
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
  resources :favorites

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get ":faction/info" => "factions#base", as: :base
  get ":faction/datasheets" => "factions#datasheets", as: :all
  get ":faction/datasheets/:type" => "factions#type", as: :type
  get ":username/favorite" => "favorites#mine", as: :my_favs
  post "favorite/new" => "favorites#create", as: :new_fav
 
  delete "delete_favorite/:id" => "favorites#destroy", as: :delete_favorite
  get "update_model/:unit_id/:id" =>"models#update", as: :update_model
  root "factions#home"
end
