class UpdateSpreeMakeEasyProductsToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :spree_make_easy_products, version: 2, revert_to_version: 1
  end
end

# touched on 2025-05-22T19:22:42.384696Z
# touched on 2025-05-22T20:32:14.950029Z
# touched on 2025-05-22T21:57:28.638044Z
# touched on 2025-05-22T23:05:27.270564Z
# touched on 2025-05-22T23:48:18.386302Z
