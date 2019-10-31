Rails.application.routes.draw do
  get 'intros/index'
   resources :products,:orders,:quantities
   resources  :carts do
	   collection do
	    get 'delete_product_from_cart'
	   end
	 end
	  resources  :wishlists do
	 	  collection do
	 	    get 'delete_product_from_wishlist'
	    end
	 	end
  root to: 'welcomes#index'
	devise_for :users, controllers: { registrations: "users/registrations" , sessions: "users/sessions", omniauth_callbacks: 'users/omniauth_callbacks' , passwords: "users/passwords"}
end
