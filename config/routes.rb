Rails.application.routes.draw do
  get 'intros/index'
  get'startups/index'
  resources :products,:orders,:carts,:wishlists
  root to: 'welcomes#index'
	devise_for :users, controllers: { registrations: "users/registrations" , sessions: "users/sessions", omniauth_callbacks: 'users/omniauth_callbacks' , passwords: "users/passwords"}
end
