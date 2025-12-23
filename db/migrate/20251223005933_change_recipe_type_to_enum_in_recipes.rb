class ChangeRecipeTypeToEnumInRecipes < ActiveRecord::Migration[7.0]
  def up
    # Add new integer column
    add_column :recipes, :recipe_type_tmp, :integer, null: false, default: 0

    # Migrate existing string data safely
    execute <<~SQL
      UPDATE recipes
      SET recipe_type_tmp =
        CASE recipe_type
          WHEN 'prepped_item' THEN 0
          WHEN 'menu_item' THEN 1
          ELSE 0
        END
    SQL

    # Remove old column and rename
    remove_column :recipes, :recipe_type
    rename_column :recipes, :recipe_type_tmp, :recipe_type
  end

  def down
    add_column :recipes, :recipe_type_tmp, :string

    execute <<~SQL
      UPDATE recipes
      SET recipe_type_tmp =
        CASE recipe_type
          WHEN 0 THEN 'prepped_item'
          WHEN 1 THEN 'menu_item'
        END
    SQL

    remove_column :recipes, :recipe_type
    rename_column :recipes, :recipe_type_tmp, :recipe_type
  end
end
