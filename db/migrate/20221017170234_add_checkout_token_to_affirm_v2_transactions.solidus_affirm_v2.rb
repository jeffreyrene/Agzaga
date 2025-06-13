# This migration comes from solidus_affirm_v2 (originally 20200518191753)
class AddCheckoutTokenToAffirmV2Transactions < ActiveRecord::Migration[5.1]
  def change
    add_column :solidus_affirm_v2_transactions, :checkout_token, :string
  end
end

# touched on 2025-05-22T19:07:21.235957Z
# touched on 2025-05-22T23:26:54.472017Z
# touched on 2025-05-22T23:30:06.123223Z
