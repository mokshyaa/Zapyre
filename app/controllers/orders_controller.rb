class OrdersController < ApplicationController

  after_action :add_to_orders_products , only: [:create]
  before_action :get_order , only: [:destroy]

	def index
		@orders = Order.all
	end
		
	def create
	  @order = Order.new(order_params)
	  @order.user_id = current_user.id
	   	begin
			  if @order.save		
			 	  redirect_to orders_url
			  end 	
			rescue StandardError => e
				print e
			end 	
	end
	
	def destroy
		begin
			if @order.destroy
	    	respond_to do |format|
	    	  format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
	    	end
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
	#add record to join tables
	def add_to_orders_products
		begin
		  @product = Product.find(params[:product_id])
		  @product.orders << @order
		  flash[:notice] = 'Product was saved.'
	  rescue StandardError => e
   	  print e
    end
	end
end
