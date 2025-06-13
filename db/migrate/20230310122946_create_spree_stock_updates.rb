class CreateSpreeStockUpdates < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_stock_updates do |t|
      t.string :email
      t.boolean :process, default: false
      t.integer :variant_id

      t.timestamps
    end
  end
end

# touched on 2025-05-22T22:34:30.264054Z
# touched on 2025-05-22T23:30:34.152928Z
