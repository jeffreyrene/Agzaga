class UpdateSpreeStartYoungProductsToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :spree_start_young_products, version: 2, revert_to_version: 1
  end
end

# touched on 2025-05-22T22:38:51.644638Z
# touched on 2025-05-22T22:59:51.541475Z
# touched on 2025-05-22T23:44:27.715723Z
