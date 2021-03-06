# frozen_string_literal: true

class CreateQuantities < ActiveRecord::Migration[5.2]
  def change
    create_table :quantities do |t|
      t.integer :quantity
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
