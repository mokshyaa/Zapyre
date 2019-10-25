class Quantity < ApplicationRecord
  belongs_to :product 
  belongs_to :qnt, polymorphic: true 
  validates :quantity, presence: true ,numericality: {greater_than: 0}
end
