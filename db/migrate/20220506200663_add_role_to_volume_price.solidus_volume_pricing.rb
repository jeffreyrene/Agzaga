# frozen_string_literal: true
# This migration comes from solidus_volume_pricing (originally 20150513200904)

class AddRoleToVolumePrice < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_volume_prices, :role_id, :integer
  end
end

# touched on 2025-05-22T23:42:05.869963Z
# touched on 2025-05-22T23:45:33.091072Z
