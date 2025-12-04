class MakeRecipeIngredientsPolymorphic < ActiveRecord::Migration[7.0]
  def change
    remove_column :recipe_ingredients, :product_id, :integer

    add_column :recipe_ingredients, :ingredient_id, :integer
    add_column :recipe_ingredients, :ingredient_type, :string

    add_index :recipe_ingredients, [:ingredient_type, :ingredient_id], 
              name: "index_recipe_ingredients_on_ingredient"
  end
end
