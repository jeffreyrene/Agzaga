class CreateAddsOnsProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_adds_ons_products do |t|
      t.references :product
      t.timestamps
    end
  end
end

# touched on 2025-05-22T20:38:16.646145Z
# touched on 2025-05-22T20:41:06.625179Z
# touched on 2025-05-22T21:34:17.189238Z
