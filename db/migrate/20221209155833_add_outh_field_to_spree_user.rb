class AddOuthFieldToSpreeUser < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_users, :uid, :string
    add_column :spree_users, :provider, :string, default: "email"
  end
end

# touched on 2025-05-22T22:34:51.841664Z
# touched on 2025-05-22T22:55:10.198192Z
