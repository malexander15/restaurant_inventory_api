class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :unit
      t.float :stock_quantity
      t.string :upc_code

      t.timestamps
    end
  end
end
