class CreateSpreePickUpPeople < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_pick_up_people do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.integer :order_id

      t.timestamps
    end
  end
end

# touched on 2025-05-22T19:10:39.310129Z
# touched on 2025-05-22T19:16:13.073182Z
# touched on 2025-05-22T20:38:41.163409Z
# touched on 2025-05-22T22:44:09.653098Z
# touched on 2025-05-22T23:26:26.181542Z
