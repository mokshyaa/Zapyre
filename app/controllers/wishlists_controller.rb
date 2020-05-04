# frozen_string_literal: true

class WishlistsController < ApplicationController
  def index
    @wishlist = current_user.wishlist
  end

  def create
    UserWishlist.new.create(current_user)
    add_to_products_wishlists
  rescue StandardError => e
    print e
  end

  # remove indidividual product from wishlist
  def remove_product_from_wishlist
    product = current_user.wishlist.products.where(id: params[:id].to_i).first
    if UserWishlist.new.remove_product(current_user.wishlist, product)
      redirect_to wishlists_path
      flash[:alert] = "Product #{product.id} removed from wishlist"
    else
      flash[:error] = 'Something goes wrong!'
    end
  end

  private

  # add record to join tables uniquely
  def add_to_products_wishlists
    current_user.reload_wishlist
    begin
     UserWishlist.new.add(current_user.wishlist, params[:product_id])
     redirect_to products_path
     flash[:success] = 'Product added to wishlist'
    rescue StandardError => e
      print e
   end
   end
end
