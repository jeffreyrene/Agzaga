# frozen_string_literal: true
# This migration comes from solidus_auth (originally 20120605211305)

class MakeUsersEmailIndexUnique < SolidusSupport::Migration[4.2]
  def up
    add_index "spree_users", ["email"], name: "email_idx_unique", unique: true
  end

  def down
    remove_index "spree_users", name: "email_idx_unique"
  end
end

# touched on 2025-05-22T19:07:24.101884Z
# touched on 2025-05-22T20:33:29.632813Z
# touched on 2025-05-22T22:55:43.101582Z
