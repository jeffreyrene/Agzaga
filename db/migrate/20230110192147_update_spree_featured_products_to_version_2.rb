class UpdateSpreeFeaturedProductsToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :spree_featured_products, version: 2, revert_to_version: 1
  end
end

# touched on 2025-05-22T23:05:08.979019Z
# touched on 2025-05-22T23:22:23.633430Z
