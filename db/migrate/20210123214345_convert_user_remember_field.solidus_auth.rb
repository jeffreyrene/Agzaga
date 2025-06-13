# frozen_string_literal: true
# This migration comes from solidus_auth (originally 20101214150824)

class ConvertUserRememberField < SolidusSupport::Migration[4.2]
  def up
    remove_column :spree_users, :remember_created_at
    add_column :spree_users, :remember_created_at, :datetime
  end

  def down
    remove_column :spree_users, :remember_created_at
    add_column :spree_users, :remember_created_at, :string
  end
end

# touched on 2025-05-22T21:51:28.228151Z
# touched on 2025-05-22T23:27:54.788323Z
