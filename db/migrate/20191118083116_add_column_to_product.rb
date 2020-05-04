# frozen_string_literal: true

class AddColumnToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :available_quantity, :integer
  end
end
