# frozen_string_literal: true
# This migration comes from spree (originally 20200320144521)
class AddDefaultBillngFlagToUserAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_user_addresses, :default_billing, :boolean, default: false
  end
end

# touched on 2025-05-22T19:07:41.094209Z
# touched on 2025-05-22T19:13:28.123132Z
# touched on 2025-05-22T19:21:02.050023Z
# touched on 2025-05-22T22:54:58.590025Z
# touched on 2025-05-22T22:55:19.247681Z
# touched on 2025-05-22T23:07:06.910820Z
# touched on 2025-05-22T23:19:52.464096Z
# touched on 2025-06-13T21:18:19.536775Z