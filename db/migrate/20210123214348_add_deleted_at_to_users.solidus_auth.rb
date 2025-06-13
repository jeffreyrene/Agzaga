# frozen_string_literal: true
# This migration comes from solidus_auth (originally 20140904000425)

class AddDeletedAtToUsers < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_users, :deleted_at, :datetime
    add_index :spree_users, :deleted_at
  end
end

# touched on 2025-05-22T19:13:23.301831Z
# touched on 2025-05-22T19:18:03.150285Z
# touched on 2025-05-22T23:26:59.672414Z
# touched on 2025-06-13T21:14:47.285744Z