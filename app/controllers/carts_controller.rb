class CartsController < ApplicationController
	
  before_action :get_cart, only: [:destroy]
  after_action :add_to_carts_products,  only:[:create]

	def index
		@carts = Cart.all
	end

	def create
		byebug
		@cart = Cart.new(cart_params)
		@cart.user_id = current_user.id
		begin
			@cart.save		 	
		rescue StandardError => e
			print e
		end 
	end
	
	def destroy
		begin
			@cart.destroy
				respond_to do |format|
			  format.html { redirect_to carts_url, notice: 'Product was successfully destroyed.' }
				end
	  rescue StandardError => e
			print e
		end 			
	end
	
	private 

	#detect which record to be deleted
	def get_cart
		@cart = Cart.find(params[:id])
	end

  def cart_params
		params.permit(:quantity)
  end

	#add record to join tables
	def add_to_carts_products
		begin
		  @product = Product.find(params[:product_id])
		  @product.carts << @cart
		  flash[:notice] = 'Product was saved.'
		rescue StandardError => e
   	  print e
   	  
    end
  end
end
