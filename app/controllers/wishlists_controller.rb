class WishlistsController < ApplicationController

 after_action :add_to_products_wishlists, only: [:create]

	def index		
		@wishlist = current_user.wishlist
	end

	def create
		begin
			UserWishlist.new(current_user).call 
		rescue StandardError => e
		  print e
		end
	end
	
	#remove indidividual product from wishlist
  def remove_product_from_wishlist
  	product = current_user.wishlist.products.where(id: params[:id].to_i).first
   	if UserWishlist.new.remove_product(current_user.wishlist, product)
   		redirect_to wishlists_path
   	else
   		flash[:error] = "Something goes wrong!"
   	end
  end
	
	private 
 
  #add record to join tables uniquely
  def add_to_products_wishlists
 		current_user.reload_wishlist
 		begin
  		UserWishlist.new.add(current_user.wishlist,params[:product_id])
  	rescue StandardError => e
  	  print e
  	end
	end
	
end