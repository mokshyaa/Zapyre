class WishlistsController < ApplicationController
	
 before_action :get_wishlist, only: [:destroy]
 after_action :add_to_products_wishlists, only: [:create]

	def index		
		@wishlist = current_user.wishlist
	end

	def create
		if current_user.wishlist.nil? 
			@wishlist = Wishlist.new
			@wishlist.user_id = current_user.id
			if @wishlist.save
			 flash[:success] = "Added To Wishlist"
			else	
				flash[:error] = "Something goes wrong!"
			end
		end
	end
	
	def destroy
		begin
			@wishlist.destroy
			respond_to do |format|
	    	  format.html { redirect_to wishlists_url, notice: 'Product was successfully removed from wishlist.' }
	    	end
    rescue StandardError => e
   	  print e
    end
  end

  def delete_product_from_wishlist
  	product = current_user.wishlist.products.where(id: params[:id].to_i).first
   	if current_user.wishlist.products.delete(product)
   		flash[:success] = "Product removed"
   		redirect_to wishlists_path
   	else
   		flash[:error] = "Something goes wrong!"
   	end
  end
	
	private 

	#detect which record to be deleted
	def get_wishlist
   	@wishlist = Wishlist.find(params[:id])
  end
  
  #add record to join tables uniquely
  def add_to_products_wishlists
  	begin
  		current_user.reload_wishlist
  		byebug
		  Product.find(params[:product_id]).wishlists << current_user.wishlist if current_user.wishlist.products.where( id: params[:product_id]).first.nil?
	  rescue StandardError => e
   	  print e
    end
	end
	
end