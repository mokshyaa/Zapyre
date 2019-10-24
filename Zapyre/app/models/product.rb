class Product < ApplicationRecord
  has_and_belongs_to_many :orders 
  has_and_belongs_to_many :wishlists 
  has_and_belongs_to_many :carts 
  has_many :quantities 
	has_attached_file :image, styles: { large: "500x500>", medium: "300x300>", thumb: "50X50>" }, default_url: "product.png"
  validates_attachment_content_type :image, content_type: ["image/jpeg", "image/gif", "image/png"] 
  validates :name, presence: true, length: { minimum: 3 }
  validates :price, presence: true, numericality: true
  validates :brand, presence: true
  validates :description, presence: true
  validates :offer, presence: true
end

