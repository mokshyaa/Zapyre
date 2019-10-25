class OrdersController < ApplicationController

  before_action :get_order , only: [:destroy]
  skip_before_action :verify_authenticity_token
  after_action :add_to_orders_products , only: [:create]

	def index
		@orders = current_user.orders.includes(:products)
	end
		
	def create
			@order = Order.new(order_params)
			@order.user_id = current_user.id
			@order.save
	end
	
	def destroy
		begin
   	  @order.destroy
   	  redirect_to orders_path
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
  	params.permit(:total)
	end

	#add record to join tables for multiple products 
	def add_to_orders_products
		begin
		current_user.orders.reload 	
		current_user.cart.products.each do |cart_product|
			cart_product.orders << @order	if !cart_product.nil?
			if cart_product.orders
					#change qnt_type in quantities table from 'Cart' to 'Order'
					@quantity = cart_product.quantities.where(qnt_id: current_user.cart.id).first
	 				@quantity.qnt_type.sub!(/Cart/, 'Order')
	 				@quantity.qnt_id = @order.id
	 				@quantity.save
				end
			end	
			current_user.cart.destroy	
	  rescue StandardError => e
   	  print e
    end
	end
	
end
