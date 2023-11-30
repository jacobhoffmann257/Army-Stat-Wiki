Rails.application.routes.draw do
  
  # Routes for the Unit keyword resource:

  # CREATE
  post("/insert_unit_keyword", { :controller => "unit_keywords", :action => "create" })
          
  # READ
  get("/unit_keywords", { :controller => "unit_keywords", :action => "index" })
  
  get("/unit_keywords/:path_id", { :controller => "unit_keywords", :action => "show" })
  
  # UPDATE
  
  post("/modify_unit_keyword/:path_id", { :controller => "unit_keywords", :action => "update" })
  
  # DELETE
  get("/delete_unit_keyword/:path_id", { :controller => "unit_keywords", :action => "destroy" })

  #------------------------------

  # Routes for the Keyword resource:

  # CREATE
  post("/insert_keyword", { :controller => "keywords", :action => "create" })
          
  # READ
  get("/keywords", { :controller => "keywords", :action => "index" })
  
  get("/keywords/:path_id", { :controller => "keywords", :action => "show" })
  
  # UPDATE
  
  post("/modify_keyword/:path_id", { :controller => "keywords", :action => "update" })
  
  # DELETE
  get("/delete_keyword/:path_id", { :controller => "keywords", :action => "destroy" })

  #------------------------------

  # Routes for the Bodyguard resource:

  # CREATE
  post("/insert_bodyguard", { :controller => "bodyguards", :action => "create" })
          
  # READ
  get("/bodyguards", { :controller => "bodyguards", :action => "index" })
  
  get("/bodyguards/:path_id", { :controller => "bodyguards", :action => "show" })
  
  # UPDATE
  
  post("/modify_bodyguard/:path_id", { :controller => "bodyguards", :action => "update" })
  
  # DELETE
  get("/delete_bodyguard/:path_id", { :controller => "bodyguards", :action => "destroy" })

  #------------------------------

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
  #get "datasheets/:faction" => "factions#datasheets", as: :faction_unit
  get ":faction/datasheets" => "factions#datasheets", as: :faction_unit
  root "factions#index"
end
