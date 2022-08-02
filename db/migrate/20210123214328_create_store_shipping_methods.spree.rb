# frozen_string_literal: true
# This migration comes from spree (originally 20180202222641)

class CreateStoreShippingMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_store_shipping_methods do |t|
      t.references :store, null: false
      t.references :shipping_method, null: false

      t.timestamps precision: 6
    end
  end
end

# touched on 2025-05-22T22:32:15.381472Z
# touched on 2025-05-22T23:39:20.931220Z
