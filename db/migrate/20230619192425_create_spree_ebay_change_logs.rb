class CreateSpreeEbayChangeLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_ebay_change_logs do |t|
      t.string  :sku
      t.string  :field_name
      t.string  :old_value
      t.string  :new_value
      t.timestamps
    end
  end
end

# touched on 2025-05-22T22:29:04.570460Z
# touched on 2025-05-22T22:46:45.205285Z
# touched on 2025-05-22T23:19:29.800697Z
