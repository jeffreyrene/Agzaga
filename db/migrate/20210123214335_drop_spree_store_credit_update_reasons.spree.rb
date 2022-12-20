# frozen_string_literal: true
# This migration comes from spree (originally 20190220093635)

class DropSpreeStoreCreditUpdateReasons < ActiveRecord::Migration[5.1]
  # This migration should run in a subsequent deploy after 20180710170104
  # has been already deployed. See also migration 20180710170104.

  # We can't add back the table in a `down` method here: a previous version
  # of migration 20180710170104 would fail with `table already exists` , as
  # it handles itself the add/remove of this table and column.
  def up
    if table_exists? :spree_store_credit_update_reasons
      drop_table :spree_store_credit_update_reasons
    end

    if column_exists? :spree_store_credit_events, :update_reason_id
      remove_column :spree_store_credit_events, :update_reason_id
    end
  end
end

# touched on 2025-05-22T19:22:29.267724Z
# touched on 2025-05-22T22:55:07.796653Z
# touched on 2025-05-22T23:00:15.472435Z
# touched on 2025-05-22T23:22:45.324938Z
# touched on 2025-05-22T23:42:23.608179Z
# touched on 2025-05-22T23:44:22.385942Z
