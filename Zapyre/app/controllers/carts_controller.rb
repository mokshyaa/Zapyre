class CartsController < ApplicationController
	
  before_action :get_cart, only: [:destroy]
  before_action :check_for_similar_products, only: [:create]
  skip_before_action :verify_authenticity_token
  after_action :add_to_carts_products,  only:[:create]
  after_action :add_to_quantities,  only:[:create]
  
	def index
		@cart = current_user.cart
	end

	def create
		if current_user.cart.nil? 
		  @cart = Cart.new
			@cart.user_id = current_user.id
			@cart.save 
		end
	end

	def destroy
		begin
			@cart.destroy
				respond_to do |format|
			  	format.html { redirect_to @cart, notice: 'Product was successfully removed from cart.' }
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

  def q_params
		params.permit(:quantity, :product_id)
  end

	#add record to join tables
	def add_to_carts_products
		begin
			current_user.reload_cart
		  (Product.find(params[:product_id]).carts << current_user.cart) if params[:quantity].to_i > 0
		  #delete product from wishlist if you trying to add same product in the cart.
		  current_user.wishlist.delete if !current_user.wishlist.nil? && current_user.wishlist.products.where(id: params[:product_id].to_i)
	  rescue StandardError => e
  	  print e
    end
  end

  #add record to quantities tables
	def add_to_quantities
		current_user.reload_cart
  	begin
 			@quantity = Quantity.new(q_params)
 			@quantity.qnt_type = 'Cart'
 			@quantity.qnt_id = current_user.cart.id
 			@quantity.save
	  rescue StandardError => e
			print e
		end 
	end

  #If same product is in cart then update the quantity value
  def check_for_similar_products
  	if !current_user.cart.nil?
  		current_user.cart.products.each do |product|
  			if product.id == params[:product_id].to_i
  				#delete product from wishlist if same product is in cart and you trying to add same product in the cart.
  				current_user.wishlist.delete if !current_user.wishlist.nil? && current_user.wishlist.products.where(id: params[:product_id].to_i)
					 redirect_to carts_path if product.quantities.where(qnt_type: 'Cart', qnt_id: current_user.cart.id).first.increment(:quantity, params[:quantity].to_i).save
	 			end
	 		end	
	 	end
	end


end


