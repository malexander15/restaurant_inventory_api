class FixBarcodeIndexOnProducts < ActiveRecord::Migration[7.0]
  def change
    remove_index :products, :barcode
    add_index :products, [:restaurant_id, :barcode], unique: true
  end
end
