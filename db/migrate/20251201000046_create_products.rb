class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string  :name, null: false
      t.string  :barcode, unique: true
      t.integer :unit, null: false   # enum: oz or pcs
      t.decimal :stock_quantity, precision: 10, scale: 2, default: 0, null: false
      t.decimal :unit_cost, precision: 10, scale: 2, default: 0, null: false

      t.string  :category
      t.string  :vendor
      t.decimal :par_level, precision: 10, scale: 2

      t.timestamps
    end

    add_index :products, :barcode, unique: true
  end
end

