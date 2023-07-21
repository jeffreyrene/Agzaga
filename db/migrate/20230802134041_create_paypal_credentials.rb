class CreatePaypalCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :paypal_credentials do |t|
      t.text :access_token
      t.datetime :access_token_expiry

      t.timestamps
    end
  end
end

# touched on 2025-05-22T20:41:04.646875Z
# touched on 2025-05-22T22:54:40.421161Z
