# This migration comes from solidus_affirm (originally 20170117145716)
class CreateAffirmCheckouts < SolidusSupport::Migration[4.2]
  def change
    create_table :affirm_checkouts do |t|
      t.string :token
      t.timestamps
    end
  end
end

# touched on 2025-05-22T20:34:30.293777Z
# touched on 2025-05-22T23:46:15.170316Z
