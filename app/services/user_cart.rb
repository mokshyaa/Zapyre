# frozen_string_literal: true

class UserCart
  def initialize(params)
    @params = params
    @current_quantity = params[:quantity]
    @current_product = params[:product_id]
  end

  def create(user)
    cart = user.cart
    if cart.nil?
      cart = Cart.new
      cart.user_id = user.id
      cart.save ? true : cart
    end
  end

  def add(wishlist, cart)
    current_wishlist = wishlist
    current_cart = cart
    begin
      if @current_quantity.to_i > 0
        (Product.find(@current_product).carts << current_cart)
  end
      # delete product from wishlist if you trying to add same product in the cart.
      if !current_wishlist.nil? && !current_wishlist.products.where(id: @current_product).first.nil?
        UserWishlist.new.remove_product(current_wishlist, @current_product)
  end
      return true
    rescue StandardError => e
      print e
    end
  end

  def to_quantities(cart)
    quantity = Quantity.new(@params)
    quantity.qnt_type = 'Cart'
    quantity.qnt_id = cart.id
    quantity.save
  rescue StandardError => e
    print e
  end

  def remove_product(cart, product)
    cart.products.delete(product) && cart.quantities.where(product_id: product.id).delete_all ? true : false
  end

  def reset(cart)
    cart.quantities.delete_all
    cart.products.delete(cart.products)
  end

  def similar_product(cart, wishlist)
    @current_cart = cart
    current_wishlist = wishlist
    if !@current_cart.nil? && !@current_cart.products.where(id: @current_product).first.nil?
      similar_product = @current_cart.products.find_by(id: @current_product)
      if similar_product
        if !current_wishlist.nil? && !current_wishlist.products.where(id: @current_product).first.nil?
          UserWishlist.new.remove_product(current_wishlist, @current_product)
  end
        increment(similar_product)
        return true
      else
        return false
       end
    end
  end

  def increment(similar_product)
    increment = similar_product.quantities.where(qnt_type: 'Cart', qnt_id: @current_cart.id).first.increment(:quantity, @current_quantity.to_i)
    if increment.quantity <= Product.find_by(id: @current_product).available_quantity
      increment.save
 end
  end
end
