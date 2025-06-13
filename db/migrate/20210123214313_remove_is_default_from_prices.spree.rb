# frozen_string_literal: true
# This migration comes from spree (originally 20160924135758)

class RemoveIsDefaultFromPrices < ActiveRecord::Migration[5.0]
  def change
    remove_column :spree_prices, :is_default, :boolean, default: true
  end
end

# touched on 2025-05-22T20:37:28.665762Z
# touched on 2025-05-22T20:40:47.341654Z
# touched on 2025-05-22T23:46:59.604469Z
