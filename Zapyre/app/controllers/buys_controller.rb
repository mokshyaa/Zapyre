class BuysController < ApplicationController
  def index
  	@bought = current_user.orders.first.products
  	@images = []
  	current_user.orders.first.products.each do |p_image|
  		@images << p_image.image
		end
  end
end
