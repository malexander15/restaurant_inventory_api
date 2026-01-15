class AddNotNullToRestaurantIds < ActiveRecord::Migration[7.0]
  def change
    change_column_null :products, :restaurant_id, false
    change_column_null :recipes, :restaurant_id, false
  end
end