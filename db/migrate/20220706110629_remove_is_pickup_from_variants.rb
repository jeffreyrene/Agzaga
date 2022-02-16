class RemoveIsPickupFromVariants < ActiveRecord::Migration[6.1]
  def change
    remove_column :spree_variants, :is_pickup, :boolean, default: false
  end
end

# touched on 2025-05-22T19:07:37.299489Z
# touched on 2025-05-22T23:04:42.793016Z
# touched on 2025-05-22T23:36:52.298101Z
