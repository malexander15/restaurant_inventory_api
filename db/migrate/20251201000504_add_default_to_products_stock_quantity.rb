class AddDefaultToProductsStockQuantity < ActiveRecord::Migration[7.0]
  def change
    change_column_default :products, :stock_quantity, from: nil, to: 0
  end
end
