# frozen_string_literal: true

class AddColumnToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :total, :float
    add_column :orders, :quantity, :integer
  end
end
