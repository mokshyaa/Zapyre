# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :get_order, only: [:destroy]
  skip_before_action :verify_authenticity_token

  def index
    @orders = current_user.orders
  end

  def create
    @result = UserOrder.new.create(current_user)
    current_user.orders.reload
    UserOrder.new.add(current_user.cart, @result)
    redirect_to orders_path
    flash[:success] = 'Order Created'
  end

  def destroy
    if UserOrder.new.cancel(@order)
      current_user.orders.reload
      redirect_to orders_path
      flash[:error] = "Order #{@order.id} Canceled"
    end
   end

  private

  # detect which record to be deleted
  def get_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.permit(:total)
  end
end
