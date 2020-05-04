# frozen_string_literal: true

class AddColumnToCart < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :quantity, :integer
  end
end
