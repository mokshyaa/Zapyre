class OrdersController < ApplicationController

  after_action :add , only: [:create]
  before_action :set_order , only: [:destroy]

	def index
		@orders = Order.all
		@products = Product.all
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

	def set_order
		begin
   	  @order = Order.find(params[:id])
   	rescue StandardError => e
   	  print e
    end
  end

  def order_params
		params.permit(:total)

	end
	def product_params
		params.permit(:product_id)
	end

	def add
	  @product = Product.find(params[:product_id])
	  @product.orders << @order
	  flash[:notice] = 'Product was saved.'
	end
end
