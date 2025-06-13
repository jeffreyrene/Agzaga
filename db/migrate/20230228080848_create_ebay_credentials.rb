class CreateEbayCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :ebay_credentials do |t|
      t.text :refresh_token
      t.text :access_token
      t.datetime :access_token_expiry

      t.timestamps
    end
  end
end

# touched on 2025-05-22T23:37:30.951066Z
