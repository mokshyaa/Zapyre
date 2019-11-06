class UserWishlist
	def create(user)
		wishlist = user.wishlist
		if wishlist.nil? 
			wishlist = Wishlist.new
			wishlist.user_id = user.id
			wishlist.save ? true : wishlist
		end
	end

	def add(wishlist,product)
		current_wishlist = wishlist
		current_product = product
		begin
		  Product.find(current_product).wishlists << current_wishlist if current_wishlist.products.where( id: current_product).first.nil?
	 	rescue StandardError => e
		  print e
	  end
	end

	def remove_product(wishlist,product)
	 wishlist.products.delete(product) ? true : product
	end
end
