class OrdersController < ApplicationController

  after_action :add_to_orders_products , only: [:create]
  before_action :get_order , only: [:destroy]
  skip_before_action :verify_authenticity_token
  before_action :check_for_similar_products, only: [:create]

	def index
		@orders = current_user.orders.includes(:products)
	end
		
	def create
		params[:quantity].split.each do |qnt|
			@order = Order.new(order_params)
			@order.quantity = qnt
			@order.user_id = current_user.id
		  @cart = Cart.where(quantity: qnt, user_id: current_user).includes(:products)
      @cart.first.destroy		
      @order.save 
	  end	
	end
	
	def destroy
		begin
			cookies[:ids].split("&").each do |dlt|
   		  current_user.orders.where(id:dlt).first.destroy
	    end	 	
		rescue StandardError => e
			print e
		end 	
 	end
	
	private 
	#detect which record to be deleted
	def get_order
		begin
   	  @order = Order.find(params[:id])
   	rescue StandardError => e
   	  print e
    end
  end

  def order_params
  	params.permit(:total,:quantity)
	end

	#add record to join tables for multiple products 
	def add_to_orders_products
		begin 	
		count = 0		
			current_user.orders.all.each do |order|
					next if order.products.exists?
						@product = Product.find((params[:product_id].split)[count])
						@product.orders << order
						count+=1
			end		
	  rescue StandardError => e
   	  print e
    end
	end

	#If same product is in order then update the quantity value
  def check_for_similar_products
   	@order_current = current_user.orders
   		@order_current.each do |p|
	   		p.products.each do |pid| 
	   			if params[:product_id].to_i ==  pid.id
	   				p.quantity += params[:quantity].to_i
		   			p.save
		   			@cart = Cart.where(quantity: params[:quantity], user_id: current_user).includes(:products)
      			@cart.first.destroy		 
		   			redirect_to carts_path
		   		end
	   		end
   	end
  end

end
