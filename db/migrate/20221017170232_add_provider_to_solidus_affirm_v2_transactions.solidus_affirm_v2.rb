# frozen_string_literal: true
# This migration comes from solidus_affirm_v2 (originally 20200427210318)

class AddProviderToSolidusAffirmV2Transactions < ActiveRecord::Migration[5.1]
  def change
    add_column :solidus_affirm_v2_transactions, :provider, :string, default: :affirm
  end
end

# touched on 2025-05-22T22:45:09.640348Z
# touched on 2025-05-22T22:55:52.020458Z
