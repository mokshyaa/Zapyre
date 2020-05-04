# frozen_string_literal: true

class RemoveQuantityFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :quantity, :integer
  end
end
