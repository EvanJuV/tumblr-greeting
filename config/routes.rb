Rails.application.routes.draw do

  root to: "static_pages#index"

  match "/auth/:provider/callback" => "sessions#create", via: [:get]
  match "/signout" => "sessions#destroy", :as => :signout, via: [:get]  

  namespace :users do
  	match "/interactions" => "interactions#index", via: [:get]
  	match "/new_post" => "interactions#new_post", via: [:post]
  	match "/interactions/change_blog" => "interactions#change_blog", via: [:post, :get]
  end
end
