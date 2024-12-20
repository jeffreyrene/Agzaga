class UpdateSpreeStartYoungProductsToVersion3 < ActiveRecord::Migration[6.1]
  def change
    update_view :spree_start_young_products, version: 3, revert_to_version: 2
  end
end

# touched on 2025-05-22T20:41:47.299177Z

# touched on 2025-06-13T21:20:26.342867Z