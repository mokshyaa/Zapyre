class OrdersController < ApplicationController

  before_action :get_order , only: [:destroy]
  before_action :check_for_similar_products, only: [:create]
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

	#If same product is in order then update the quantity of that product and won't create another.
  def check_for_similar_products
		if !current_user.orders.first.nil? 	&& !current_user.cart.nil? && !current_user.cart.quantity.each {|p| return true if p.product_id == (current_user.orders.each {|o| true if o.quantity.first.quantity }) }.nil?
			current_user.cart.products.each do|cart_product|
				current_user.orders.each do|order|
					order.quantity.find_by(product_id: cart_product.id).increment(:quantity ,current_user.cart.quantity.find_by(product_id: cart_product.id).quantity).save if !order.quantity.find_by(product_id: cart_product.id).nil?
				end
			end
			redirect_to orders_path	if current_user.cart.products.each {|p| current_user.cart.quantity.find_by(product_id: p.id).destroy } && current_user.cart.destroy	
		end 			
  end

end
