# frozen_string_literal: true

class ProductDecorator < ApplicationDecorator
  delegate_all

  def image
    result = object.image.url.present? ? object.image.url : 'product.png'
    h.image_tag result
  end

  def avatar
    if object.avatar.present?
      h.image_tag(object.avatar)
    else
      h.image_tag(object.gavatar_url)
    end
  end

  def name
    get_info object.name
  end

  def price
    get_info object.price
  end

  def brand
    get_info object.brand
  end

  def decription
    get_info object.decription
  end

  def offer
    get_info object.offer
  end

  def created_at
    object.created_at.strftime('%B %e, %Y')
  end

  private

  def get_info(value)
    value.present? ? value : t('undefined')
  end
end
