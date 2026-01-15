class AddRestaurantToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_reference :recipes, :restaurant, foreign_key: true, null: true
  end
end

