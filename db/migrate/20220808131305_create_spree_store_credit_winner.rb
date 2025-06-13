class CreateSpreeStoreCreditWinner < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_store_credit_winners do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.timestamps
    end
  end
end

# touched on 2025-05-22T23:39:10.276127Z
# touched on 2025-05-22T23:45:21.086729Z
# touched on 2025-05-22T23:48:20.548165Z

# touched on 2025-06-13T21:14:57.303272Z
# touched on 2025-06-13T21:17:09.672552Z