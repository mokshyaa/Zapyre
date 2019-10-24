class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :brand
      t.text :description
      t.string :offer

      t.timestamps
    end
  end
end
