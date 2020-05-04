# frozen_string_literal: true

class OrderDecorator < Draper::Decorator
  delegate_all
  include Draper::ViewHelpers

  attr_reader :object, :decorator_class

  attr_accessor :context

  def initialize(object, options = {})
    options.assert_valid_keys(:with, :context)
    @object = object
    @decorator_class = options[:with]
    @context = options.fetch(:context, {})
  end

  def decorated_collection
    @decorated_collection ||= object.map { |item| decorate_item(item) }
  end

   private

  def decorate_item(item)
    item_decorator.call(item, context: context)
  end

  def item_decorator
    if decorator_class
      decorator_class.method(:decorate)
    else
      ->(item, options) { item.decorate(options) }
    end
  end
 end
