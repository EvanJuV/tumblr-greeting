Rails.application.routes.draw do

  root to: "static_pages#index"

  match "auth/:provider/callback" => "sessions#create", via: [:get]
  match "/signout" => "sessions#destroy", :as => :signout, via: [:get]  

  namespace :users do
  	resources :interactions
  	match "/new_post" => "interactions#new_post", via: [:post]
  end
end
