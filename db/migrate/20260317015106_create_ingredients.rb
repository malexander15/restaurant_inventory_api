class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :unit
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
