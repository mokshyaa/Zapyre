class CreateJoinTableProdcutsOrders < ActiveRecord::Migration[5.2]
  def change
    create_join_table :products, :orders do |t|
      # t.index [:product_id, :order_id]
      # t.index [:order_id, :product_id]
    end
  end
end
