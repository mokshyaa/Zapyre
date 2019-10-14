class WishlistsController < ApplicationController
 before_action :set_wishlist, only: [:destroy]
 after_action :add, only: [:create]

	def index
		@wishlists = Wishlist.all
		@products = Product.all
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
		@wishlist.destroy
		respond_to do |format|
    	  format.html { redirect_to wishlists_url, notice: 'Product was successfully destroyed.' }
    	end
    end
	
	private 

	def set_wishlist
     	@wishlist = Wishlist.find(params[:id])
    end

    def add
	  @product = Product.find(params[:product_id])
	  @product.wishlists << @wishlist
	  flash[:notice] = 'Product was saved.'
	end
    

end
