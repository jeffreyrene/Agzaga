class UpdateSpreeFeaturedProductsToVersion3 < ActiveRecord::Migration[6.1]
  def change
    update_view :spree_featured_products, version: 3, revert_to_version: 2
  end
end

# touched on 2025-05-22T22:38:51.644024Z
# touched on 2025-05-22T22:44:13.281669Z
# touched on 2025-05-22T22:45:44.587692Z
