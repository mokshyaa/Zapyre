class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products
  validates :quantity, presence: true ,numericality: true 
end
