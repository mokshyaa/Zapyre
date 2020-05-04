# frozen_string_literal: true

class UserWishlist
  def create(user)
    wishlist = user.wishlist
    if wishlist.nil?
      wishlist = Wishlist.new
      wishlist.user_id = user.id
      wishlist.save ? true : wishlist
    end
  end

  def add(wishlist, product)
    current_wishlist = wishlist
    current_product = product
    begin
      if current_wishlist.products.where(id: current_product).first.nil?
        Product.find(current_product).wishlists << current_wishlist
   end
    rescue StandardError => e
      print e
    end
  end

  def remove_product(wishlist, product)
    wishlist.products.delete(product) ? true : product
  end
end
