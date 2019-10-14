class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products 
  before_save :order_total 

  private
 
   def order_total
 
    	@products.each do |product|
  	 	  product.orders.each do |order| 
  			  @orders.each do |order_main| 
		  			if order.id == order_main.id						  				
		  				order_main.total = product.price * @get_quantity
		  				order.total = order_main.total
		  			end
		  		end
		  	end
			end
		end
	end






	
			

