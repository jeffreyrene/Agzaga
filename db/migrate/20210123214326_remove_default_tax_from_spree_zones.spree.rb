# frozen_string_literal: true
# This migration comes from spree (originally 20170831201542)

class RemoveDefaultTaxFromSpreeZones < ActiveRecord::Migration[5.1]
  def change
    remove_column :spree_zones, :default_tax, :boolean, default: false
  end
end

# touched on 2025-05-22T21:34:17.187676Z
# touched on 2025-05-22T22:30:48.561117Z
# touched on 2025-05-22T22:59:47.935965Z
# touched on 2025-05-22T23:26:36.500849Z
