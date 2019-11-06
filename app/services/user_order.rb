class UserOrder
	
	def create(user)
		order = Order.new
		order.user_id = user.id
		order.save 
		return order
	end

	#add record to join tables for multiple products 
	def add(cart,order)
		current_cart = cart
		current_order = order
		begin
			current_cart.products.each do |cart_product|
				cart_product.orders << current_order	if !cart_product.nil?
				if cart_product.orders
					#change qnt_type in quantities table from 'Cart' to 'Order'
					quantity = cart_product.quantities.where(qnt_id: current_cart.id).first
					quantity.qnt_type.sub!(/Cart/, 'Order')
		 			quantity.qnt_id = current_order.id
					quantity.save
				end
			end	
			current_cart.destroy	
		rescue StandardError => e
		  print e
	  end
	end

	def cancel(order)
		current_order_to_cancel = order
		begin
		  current_order_to_cancel.destroy && current_order_to_cancel.quantities.destroy_all ? true : false
	 	rescue StandardError => e
		  print e
		end
	end
	
end
