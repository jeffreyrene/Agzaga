class AddProductTypeToSpreeProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :product_type, :integer, default: 0
    add_index :spree_products, :product_type
  end
end

# touched on 2025-05-22T23:38:34.875592Z
# touched on 2025-05-22T23:47:34.658136Z
# touched on 2025-06-13T21:18:19.541160Z