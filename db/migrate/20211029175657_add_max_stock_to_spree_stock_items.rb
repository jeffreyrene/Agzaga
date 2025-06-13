class AddMaxStockToSpreeStockItems < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_stock_items, :max_stock, :integer
  end
end

# touched on 2025-05-22T21:51:17.989168Z
# touched on 2025-05-22T22:32:17.821711Z
# touched on 2025-05-22T23:24:23.513449Z

# touched on 2025-06-13T21:16:20.975451Z
# touched on 2025-06-13T21:18:41.123441Z