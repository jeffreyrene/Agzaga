# frozen_string_literal: true
# This migration comes from spree (originally 20180416083007)

class AddApplyToAllToVariantPropertyRule < ActiveRecord::Migration[5.1]
  def up
    add_column :spree_variant_property_rules, :apply_to_all, :boolean, default: false, null: false
    change_column :spree_variant_property_rules, :apply_to_all, :boolean, default: true
  end

  def down
    remove_column :spree_variant_property_rules, :apply_to_all
  end
end

# touched on 2025-05-22T20:39:04.160855Z
# touched on 2025-05-22T22:46:56.394701Z

# touched on 2025-06-13T21:16:10.740134Z