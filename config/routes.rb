Rails.application.routes.draw do
	# authenticated :user do
	#   root :to => "interactions#index"
	# end

  root to: "static_pages#index"

  match "auth/:provider/callback" => "sessions#create", via: [:get]
  match "/signout" => "sessions#destroy", :as => :signout, via: [:get]  

  namespace :users do
	  resources :interactions
  end
end
