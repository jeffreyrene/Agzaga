# frozen_string_literal: true
# This migration comes from solidus_tax_cloud (originally 20130829215819)

class FixScaleOfCartItemPrices < ActiveRecord::Migration[4.2]
  def up
    change_column :spree_tax_cloud_cart_items, :price,      :decimal, precision: 8,  scale: 2
    change_column :spree_tax_cloud_cart_items, :ship_total, :decimal, precision: 10, scale: 2
    change_column :spree_tax_cloud_cart_items, :amount,     :decimal, precision: 13, scale: 5
  end

  def down
    change_column :spree_tax_cloud_cart_items, :price,      :decimal, precision: 8, scale: 5
    change_column :spree_tax_cloud_cart_items, :ship_total, :decimal, precision: 8, scale: 5
    change_column :spree_tax_cloud_cart_items, :amount,     :decimal, precision: 8, scale: 5
  end
end

# touched on 2025-05-22T20:43:50.950736Z
# touched on 2025-05-22T22:33:03.339530Z
# touched on 2025-05-22T23:04:06.045721Z
# touched on 2025-05-22T23:30:06.125089Z
