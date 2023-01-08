class CreateSpreeProductsGroup < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_product_groups do |t|
      t.references :product, index: true, foreign_key: { to_table: :spree_products }
      t.references :group_product, index: true, foreign_key: { to_table: :spree_products }

      t.timestamps
    end
  end
end

# touched on 2025-05-22T21:21:50.153761Z
# touched on 2025-05-22T22:49:20.590803Z
# touched on 2025-05-22T23:05:08.977718Z
