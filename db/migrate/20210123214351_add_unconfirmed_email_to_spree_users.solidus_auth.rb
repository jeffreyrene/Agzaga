# This migration comes from solidus_auth (originally 20200417153503)
class AddUnconfirmedEmailToSpreeUsers < SolidusSupport::Migration[5.1]
  def change
    unless column_exists?(:spree_users, :unconfirmed_email)
      add_column :spree_users, :unconfirmed_email, :string
    end
  end
end

# touched on 2025-05-22T19:23:43.761514Z
# touched on 2025-05-22T20:44:46.382376Z
# touched on 2025-05-22T22:49:39.567733Z
# touched on 2025-05-22T23:04:21.633388Z
# touched on 2025-05-22T23:19:17.272258Z
# touched on 2025-05-22T23:48:39.216015Z
