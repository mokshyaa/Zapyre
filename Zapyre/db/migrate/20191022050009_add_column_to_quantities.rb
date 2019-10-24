class AddColumnToQuantities < ActiveRecord::Migration[5.2]
  def change
    add_reference :quantities, :qnt, polymorphic: true
  end
end
