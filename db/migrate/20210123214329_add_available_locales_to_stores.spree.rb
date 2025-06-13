# frozen_string_literal: true
# This migration comes from spree (originally 20180313220213)

class AddAvailableLocalesToStores < ActiveRecord::Migration[5.1]
  def change
    change_table :spree_stores do |t|
      t.column :available_locales, :string
    end
  end
end

# touched on 2025-05-22T21:19:01.078848Z
# touched on 2025-05-22T21:30:28.108233Z
# touched on 2025-05-22T21:58:11.114917Z
