class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products 
  accepts_nested_attributes_for :products
  after_initialize :get_quantity
  before_save :order_total 
	#	before_save :set_product , on: :create

  private

  #def set_product
  	#@product = Product.find(params[:product_id])
  #end

  #params = {order: { products_attributes: [ :product_id ]}
	#	}
   def order_total
   	@products = Product.all
   	@carts = Cart.all
   	@orders = Order.all
    	@products.each do |product|
  	 	  product.orders.each do |order| 
  			  @orders.each do |order_main| 
		  			if order.id == order_main.id						  				
		  				order_main.total = product.price * @get_quantity 
		  			end
		  		end
		  	end
			end
		end
	end

		def get_quantity
		 	@products = Product.all
	   	@carts = Cart.all
	   	@orders = Order.all
	   	@get_quantity = []
		  				 	@products.each do |product|
		  				 		product.carts.each do |cart|
		  				 			@carts.each do |cart_main|
		  				 				if cart.id == cart_main.id
		  				 					@get_quantity = cart.quantity
		  				 				end
		  				 			end
		  				 		end
		  				 	end
		  				end




	
			

