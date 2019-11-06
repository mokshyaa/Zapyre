class CartDecorator < ApplicationDecorator
  delegate_all

   delegate_all
  include Draper::ViewHelpers

  def name
     get_info object.name
  end

	def price
	   get_info object.price
	end

	def brand
	   get_info object.brand
	end

	def description
	   get_info object.description
	end

	def offer
	   get_info object.offer
	end

	def quantity
	   get_info object.quantity
	end

	def image
	  result = object.image.url.present? ? object.image.url : 'product.png'
	end


  private

  def get_info value
    value.present? ? value : t('undefined')
  end


end
