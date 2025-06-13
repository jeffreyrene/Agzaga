class AddTrackingUrlToShipments < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_shipments, :tracking_lookup, :string
  end
end

# touched on 2025-05-22T20:41:08.724083Z
# touched on 2025-05-22T20:44:52.209660Z
# touched on 2025-05-22T23:06:01.616330Z
# touched on 2025-06-13T21:16:56.184074Z