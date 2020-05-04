# frozen_string_literal: true

Rails.application.routes.draw do
  get 'intros/index'
  resources :products, :orders, :quantities
  resources :carts do
    collection do
      get 'remove_product_from_cart'
    end
  end
  resources :wishlists do
    collection do
      get 'remove_product_from_wishlist'
    end
  end
  root to: 'welcomes#index'
  post '/card' => 'billing#create_card', as: :create_payment_method
  get '/billing/new' => 'billing#new_card', as: :add_payment_method
  get '/success' => 'billing#success', as: :success
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'users/passwords'
  }
end
