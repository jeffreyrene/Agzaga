# frozen_string_literal: true
# This migration comes from spree (originally 20200530111458)

class AddBccEmailToSpreeStores < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_stores, :bcc_email, :string
  end
end

# touched on 2025-05-22T23:30:29.000625Z
# touched on 2025-05-22T23:30:55.198931Z
# touched on 2025-06-13T21:17:29.968707Z