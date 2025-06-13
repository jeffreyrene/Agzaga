class CreateSpreeUpsellProducts < ActiveRecord::Migration[6.1]
  def change
    create_view :spree_upsell_products
  end
end

# touched on 2025-05-22T19:24:45.826262Z
