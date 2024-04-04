class AddFacebookIdToSpreeProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :facebook_id, :string
  end
end

# touched on 2025-05-22T19:10:26.664151Z
# touched on 2025-05-22T20:32:17.596834Z
# touched on 2025-05-22T23:18:41.208416Z

# touched on 2025-06-13T21:16:13.473760Z