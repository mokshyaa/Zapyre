class CreateJoinTableProdcutsWishlists < ActiveRecord::Migration[5.2]
  def change
    create_join_table :products, :wishlists do |t|
      # t.index [:product_id, :wishlist_id]
      # t.index [:wishlist_id, :product_id]
    end
  end
end
