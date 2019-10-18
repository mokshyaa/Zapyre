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
		  @product = Product.find(params[:product_id])
		  @product.carts << @cart
		  flash[:notice] = 'Product was saved.'
		  @wishlist = Wishlist.where(user_id: current_user).includes(:products)
			10.times{|count|
				if @wishlist[count+1].products.first.id == @cart.products.first.id
					@wishlist[count+1].destroy
					redirect_to carts_path
					break
				end
				}
		rescue StandardError => e
   	  print e
    end
  end

  #If same product is in cart then update the quantity value
  def check_for_similar_products
  	@wishlist_current = Wishlist.where(user_id: current_user.id)
  	@cart_current = Cart.where(user_id: current_user.id)
   		@cart_current.each do |p|
	   		p.products.each do |pid| 
	   			if params[:product_id].to_i ==  pid.id
	   				p.quantity += params[:quantity].to_i
		   			p.save
		   		unless @wishlist.nil?
		   				10.times{|count|
							if @wishlist_current[count+1].products.first.id == pid.id
								@wishlist_current[count+1].destroy
								break
							end
							}
					end
		   			redirect_to carts_path
		   		end
	   		end
   	end
  end

end
