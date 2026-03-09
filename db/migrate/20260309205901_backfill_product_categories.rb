class BackfillProductCategories < ActiveRecord::Migration[7.0]
  def up
    Product.find_each do |product|
      next if product.category.blank?

      category = ProductCategory.find_or_create_by!(
        name: product.category.strip,
        restaurant_id: product.restaurant_id
      )

      product.update_column(:product_category_id, category.id)
    end
  end

  def down
  end
end