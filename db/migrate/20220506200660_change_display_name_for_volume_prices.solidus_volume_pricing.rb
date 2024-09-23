# frozen_string_literal: true
# This migration comes from solidus_volume_pricing (originally 20110203174010)

class ChangeDisplayNameForVolumePrices < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :volume_prices, :display, :name
  end

  def self.down
    rename_column :volume_prices, :name, :display
  end
end

# touched on 2025-05-22T22:58:56.665459Z
# touched on 2025-05-22T23:04:31.605506Z

# touched on 2025-06-13T21:19:09.200811Z