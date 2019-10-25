class Wishlist < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products , dependent: :destroy
end
