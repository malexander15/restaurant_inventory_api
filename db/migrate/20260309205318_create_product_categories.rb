class CreateProductCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :product_categories do |t|
      t.string :name, null: false
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end

    add_index :product_categories, [:restaurant_id, :name], unique: true
  end
end