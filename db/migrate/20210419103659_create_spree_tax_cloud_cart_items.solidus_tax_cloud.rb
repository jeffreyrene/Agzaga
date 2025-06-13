# frozen_string_literal: true
# This migration comes from solidus_tax_cloud (originally 20121220193944)

class CreateSpreeTaxCloudCartItems < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_tax_cloud_cart_items do |t|
      t.integer :index
      t.integer :tic
      t.string  :sku
      t.integer :quantity
      t.decimal :price, precision: 8, scale: 5, default: 0
      t.decimal :amount, precision: 8, scale: 5, default: 0
      t.decimal :ship_total, precision: 8, scale: 5, default: 0
      t.references :line_item
      t.references :tax_cloud_transaction
      t.string :type

      t.timestamps null: false
    end
    add_index :spree_tax_cloud_cart_items, :line_item_id
    add_index :spree_tax_cloud_cart_items, :tax_cloud_transaction_id
  end
end

# touched on 2025-05-22T19:13:49.374305Z
# touched on 2025-05-22T19:18:05.930490Z
# touched on 2025-05-22T19:20:55.815187Z
# touched on 2025-05-22T20:38:26.103236Z
# touched on 2025-05-22T20:43:33.010680Z
