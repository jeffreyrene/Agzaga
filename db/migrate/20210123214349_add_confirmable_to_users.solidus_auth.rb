# frozen_string_literal: true
# This migration comes from solidus_auth (originally 20141002154641)

class AddConfirmableToUsers < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_users, :confirmation_token, :string
    add_column :spree_users, :confirmed_at, :datetime
    add_column :spree_users, :confirmation_sent_at, :datetime
  end
end

# touched on 2025-05-22T19:22:07.593711Z
# touched on 2025-05-22T23:27:14.156833Z
# touched on 2025-05-22T23:30:55.199984Z
# touched on 2025-06-13T21:16:04.380181Z