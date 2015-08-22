Rails.application.routes.draw do
	authenticated :user do
	  root :to => "posts#index"
	end

  root to: "static_pages#index"

  match "auth/:provider/callback" => "sessions#create", via: [:get]

  resources :posts
end
