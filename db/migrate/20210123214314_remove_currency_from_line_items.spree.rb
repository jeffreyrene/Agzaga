# frozen_string_literal: true
# This migration comes from spree (originally 20161009141333)

class RemoveCurrencyFromLineItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :spree_line_items, :currency, :string
  end
end

# touched on 2025-05-22T19:19:08.238924Z
# touched on 2025-05-22T23:27:46.265367Z
