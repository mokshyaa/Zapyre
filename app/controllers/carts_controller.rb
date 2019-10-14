class CartsController < ApplicationController

 before_action :set_cart, only: [:destroy]
 after_action :add,  only:[:create]


	def index
		@carts = Cart.all
		@products = Product.all

	end

	def create
		@cart = Cart.new(cart_params)
		@cart.user_id = current_user.id
		begin
			@cart.save		 	
		rescue StandardError => e
			print e
		end 	
	end
	
	def destroy
		@cart.destroy
		respond_to do |format|
	  format.html { redirect_to carts_url, notice: 'Product was successfully destroyed.' }
	end
	end
	
	private 
	  def set_cart
		@cart = Cart.find(params[:id])
	end

	  def cart_params
			params.permit(:quantity)
	  end


	def add
	  @product = Product.find(params[:product_id])
	  @product.carts << @cart
	  flash[:notice] = 'Product was saved.'
		end

end
