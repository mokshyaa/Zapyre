class CartsController < ApplicationController
	
  before_action :get_cart, only: [:destroy]
  before_action :check_for_similar_products, only: [:create]
  after_action :add_to_carts_products,  only:[:create]

	def index
		@cart = Cart.where(user_id: current_user.id).includes(:products)
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

  def cart_params
		params.permit(:quantity)
  end

	#add record to join tables
	def add_to_carts_products
		begin
		  Product.find(params[:product_id]).carts << @cart
		  #delete product from wishlist if you trying to add same product in the cart.
			@wishlist_current = Wishlist.where(user_id: current_user.id).includes(:products).where('products.id=  ?',params[:product_id]).references(:products) 
	 		@wishlist_current.first.destroy if !@wishlist_current.first.nil?	
			redirect_to carts_path
		rescue StandardError => e
   	  print e
    end
  end


  #If same product is in cart then update the quantity value
  def check_for_similar_products
   	@cart_current = Cart.where(user_id: current_user.id).includes(:products).where('products.id=  ?',params[:product_id]).references(:products)
   	if !@cart_current.first.nil?
	 		@cart_current.first.quantity += params[:quantity].to_i  
		 	@cart_current.first.save
		 	#delete product from wishlist if same product is in cart and you trying to add same product in the cart.
		 	@wishlist_current = Wishlist.where(user_id: current_user.id).includes(:products).where('products.id=  ?',params[:product_id]).references(:products) 
		 	@wishlist_current.first.destroy if !@wishlist_current.first.nil?
		 	redirect_to carts_path
	 	end	
	end

end


