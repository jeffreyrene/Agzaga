# frozen_string_literal: true
# This migration comes from spree (originally 20170522143442)

class AddTimeRangeToTaxRate < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_tax_rates, :starts_at, :datetime
    add_column :spree_tax_rates, :expires_at, :datetime
  end
end

# touched on 2025-05-22T20:39:02.245940Z
# touched on 2025-05-22T23:06:11.771441Z

# touched on 2025-06-13T21:17:12.562023Z