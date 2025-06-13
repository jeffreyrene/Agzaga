# frozen_string_literal: true
# This migration comes from solidus_tax_cloud (originally 20140623225628)

class AddTicToProducts < ActiveRecord::Migration[4.2]
  def up
    add_column :spree_products, :tax_cloud_tic, :string, default: nil
  end

  def down
    remove_column :spree_products, :tax_cloud_tic
  end
end

# touched on 2025-05-22T23:19:36.190154Z
# touched on 2025-05-22T23:37:10.843378Z

# touched on 2025-06-13T21:18:19.534693Z