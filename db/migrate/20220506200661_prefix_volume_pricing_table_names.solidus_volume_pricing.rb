# frozen_string_literal: true
# This migration comes from solidus_volume_pricing (originally 20111206173307)

class PrefixVolumePricingTableNames < ActiveRecord::Migration[4.2]
  def change
    rename_table :volume_prices, :spree_volume_prices unless Spree::VolumePrice.table_exists?
  end
end

# touched on 2025-05-22T20:43:35.009702Z
# touched on 2025-05-22T22:29:10.991907Z
# touched on 2025-05-22T22:47:32.658920Z
# touched on 2025-05-22T23:27:05.497059Z
# touched on 2025-05-22T23:28:07.115159Z
# touched on 2025-05-22T23:30:17.119656Z
# touched on 2025-05-22T23:42:21.013033Z
