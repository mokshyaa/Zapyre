json.extract! product, :id, :name, :price, :brand, :description, :offer, :created_at, :updated_at
json.url product_url(product, format: :json)