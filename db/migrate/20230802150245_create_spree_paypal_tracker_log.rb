class CreateSpreePaypalTrackerLog < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_paypal_tracker_logs do |t|
      t.text :response
      t.integer :status_code
      t.string :order_id

      t.timestamps
    end
  end
end

# touched on 2025-05-22T20:33:10.001764Z
# touched on 2025-05-22T22:51:20.505486Z
# touched on 2025-05-22T23:21:27.945701Z
# touched on 2025-05-22T23:29:05.119891Z
# touched on 2025-05-22T23:37:10.845323Z
# touched on 2025-06-13T21:21:53.299038Z