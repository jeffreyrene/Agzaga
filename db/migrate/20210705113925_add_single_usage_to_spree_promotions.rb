class AddSingleUsageToSpreePromotions < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_promotions, :single_usage, :boolean, default: false
  end
end

# touched on 2025-05-22T19:09:25.632855Z
# touched on 2025-05-22T21:18:59.040955Z
