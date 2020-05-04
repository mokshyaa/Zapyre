# frozen_string_literal: true

class CartsController < ApplicationController
  include CartsHelper

  before_action :get_cart, only: [:destroy]
  before_action :check_for_similar_product, only: [:create]
  skip_before_action :verify_authenticity_token

  def index
    @cart = current_user.cart
  end

  def create
    UserCart.new(q_params).create(current_user)
    add_to_carts_products
    add_to_quantities
  rescue StandardError => e
    print e
  end

  def destroy
    if UserCart.new(q_params).reset(@cart)
      respond_to do |format|
        format.html { redirect_to carts_path, notice: 'Cart reset successfully.' }
      end
    else
      flash[:error] = 'Something goes wrong!'
    end
  end

  # remove indidividual product from cart
  def remove_product_from_cart
    product = current_user.cart.products.where(id: params[:id].to_i).first
    if UserCart.new(q_params).remove_product(current_user.cart, product)
      redirect_to carts_path, alert: "Product #{product.id} removed from cart"
      end
  end

  private

  # detect which record to be deleted
  def get_cart
    @cart = Cart.find(params[:id])
  end

  def q_params
    params.permit(:quantity, :product_id)
  end

  # add record to join tables
  def add_to_carts_products
    current_user.reload_cart
    product = Product.find_by(id: params[:product_id])
    if params[:quantity].to_i > product.available_quantity
      redirect_to products_path
      flash[:error] = "Only #{product.available_quantity} Products available !"
    else
      UserCart.new(q_params).add(current_user.wishlist, current_user.cart)
      redirect_to products_path
      flash[:success] = 'Product successfully added to the cart !'
    end
  end

  # add record to quantities tables
  def add_to_quantities
    current_user.reload_cart
    UserCart.new(q_params).to_quantities(current_user.cart)
  end

  # If same product is in cart then update the quantity value
  def check_for_similar_product
    if params[:quantity] == '' || params[:quantity].to_i <= -1
      redirect_to products_path
      flash[:error] = 'Quantity must be > 0'
    elsif UserCart.new(q_params).similar_product(current_user.cart, current_user.wishlist)
      redirect_to carts_path
      flash[:success] = "Quantity of Product #{params[:product_id]} upated"
     end
   end
end
