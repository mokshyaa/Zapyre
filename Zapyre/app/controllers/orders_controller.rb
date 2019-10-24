class OrdersController < ApplicationController

  before_action :get_order , only: [:destroy]
  before_action :check_for_similar_products, only: [:create]
  skip_before_action :verify_authenticity_token
  after_action :add_to_orders_products , only: [:create]

	def index
		@orders = current_user.orders.includes(:products)
	end
		
	def create
		if current_user.orders.first.nil?
			@order = Order.new(order_params)
			@order.user_id = current_user.id
			@order.save
	  end   
	end
	
	def destroy
		begin
   	  current_user.orders.first.destroy
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
			cart_product.orders << current_user.orders.first	if !cart_product.nil?
			if cart_product.orders
					@quantity = cart_product.quantities.where(qnt_id: current_user.cart.id).first
	 				@quantity.qnt_type.sub!(/Cart/, 'Order')
	 				@quantity.qnt_id = current_user.orders.first.id
	 				@quantity.save
				end
			end	
			current_user.cart.destroy	
	  rescue StandardError => e
   	  print e
    end
	end

	#If same product is in order then update the quantity of that product and won't create another.
  def check_for_similar_products
		if !current_user.orders.first.nil? 	&& !current_user.cart.nil?
			current_user.cart.products.each do|cart_product|
				current_user.orders.each do|order|
					order.products.where(id: cart_product.id).first.quantities.first.increment(:quantity , cart_product.quantities.first.quantity).save
				end
			end
			redirect_to orders_path	if current_user.cart.products.each {|p| true if p.id == current_user.orders.first.products.first.id  } && current_user.cart.destroy
		end 			
  end

end
