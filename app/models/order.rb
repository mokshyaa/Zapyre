# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :quantities, as: :qnt
  has_and_belongs_to_many :products, dependent: :destroy
end
