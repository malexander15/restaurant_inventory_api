class AddRestaurantToProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :restaurant, foreign_key: true, null: true
  end
end

