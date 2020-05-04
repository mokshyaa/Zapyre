# frozen_string_literal: true

class UserOrder
  def create(user)
    order = Order.new
    order.user_id = user.id
    order.save
    order
  end

  # add record to join tables for multiple products
  def add(cart, order)
    current_cart = cart
    current_order = order
    begin
      current_cart.products.each do |cart_product|
        cart_product.orders << current_order  unless cart_product.nil?
        next unless cart_product.orders

        # change qnt_type in quantities table from 'Cart' to 'Order'
        update_quantity = cart_product.quantities.where(qnt_id: current_cart.id).first
        product_total_quantity = Product.where(id: cart_product.id).first.decrement(:available_quantity, update_quantity.quantity).save
        update_quantity.qnt_type.sub!(/Cart/, 'Order')
        update_quantity.qnt_id = current_order.id
        update_quantity.save
      end
      current_cart.destroy
    rescue StandardError => e
      print e
    end
  end

  def cancel(order)
    current_order_to_cancel = order
    begin
      current_order_to_cancel.products.each do |order_product|
        temp_quantity = order_product.quantities.where(qnt_id: current_order_to_cancel.id).first.quantity
        Product.where(id: order_product.id).first.increment(:available_quantity, temp_quantity).save
      end
      current_order_to_cancel.destroy && current_order_to_cancel.quantities.destroy_all ? true : false
    rescue StandardError => e
      print e
    end
  end
end
