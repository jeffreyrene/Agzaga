class AddGoogleProductCategoryToSpreeProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :google_product_category, :integer
  end
end

# touched on 2025-05-22T20:34:16.343093Z
# touched on 2025-05-22T22:51:14.439846Z
# touched on 2025-05-22T23:46:57.058177Z
