class Cart < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products 
  validates :quantity, presence: true ,numericality:{greater_than: 0}
end
