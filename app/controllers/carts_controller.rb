class CartsController < ApplicationController
	include CartsHelper
	
  before_action :get_cart, only: [:destroy]
  before_action :check_for_similar_product, only: [:create]
  skip_before_action :verify_authenticity_token
  after_action :add_to_carts_products,  only:[:create]
  after_action :add_to_quantities,  only:[:create]
  
	def index
		@cart = current_user.cart
	end

	def create
		begin
			UserCart.new(q_params).create(current_user)
		rescue StandardError => e
		  print e
	  end
	end

	def destroy
		if UserCart.new.reset(@cart)
			respond_to do |format|
			 	format.html { redirect_to @cart, notice: 'Cart reset successfully.' }
			end
		else
			flash[:error] = "Something goes wrong!"	
		end
	end
	
	#remove indidividual product from cart
	def remove_product_from_cart
		product = current_user.cart.products.where(id: params[:id].to_i).first
	 	if UserCart.new(q_params).remove_product(current_user.cart,product)
	 		redirect_to carts_path
	 	end
	end
	
	private 

	#detect which record to be deleted
	def get_cart
		@cart = Cart.find(params[:id])
	end

  def q_params
		params.permit(:quantity, :product_id)
  end

	#add record to join tables
	def add_to_carts_products
		current_user.reload_cart
		UserCart.new(q_params).add(current_user.wishlist,current_user.cart)
  end

  #add record to quantities tables
	def add_to_quantities
		current_user.reload_cart
		UserCart.new(q_params).to_quantities(current_user.cart)
	end

  #If same product is in cart then update the quantity value
  def check_for_similar_product
  	if UserCart.new(q_params).similar_product(current_user.cart,current_user.wishlist)
  		redirect_to carts_path
  	end
	end

end


