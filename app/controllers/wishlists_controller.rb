class WishlistsController < ApplicationController
	
 before_action :get_wishlist, only: [:destroy]
 after_action :add_to_products_wishlists, only: [:create]

	def index
		@wishlists = Wishlist.all
	end

	def create
		@wishlist = Wishlist.new
		@wishlist.user_id = current_user.id
		begin
			@wishlist.save		 	
		rescue StandardError => e
			print e
		end 	
	end
	
	def destroy
		begin
			@wishlist.destroy
			respond_to do |format|
	    	  format.html { redirect_to wishlists_url, notice: 'Product was successfully destroyed.' }
	    	end
    rescue StandardError => e
   	  print e
    end
  end
	
	private 

	#detect which record to be deleted
	def get_wishlist
   	@wishlist = Wishlist.find(params[:id])
  end
  
  #add record to join tables
  def add_to_products_wishlists
  	begin
		  @product = Product.find(params[:product_id])
		  @product.wishlists << @wishlist
		  flash[:notice] = 'Product was saved.'
	  rescue StandardError => e
   	  print e
    end
	end
end
