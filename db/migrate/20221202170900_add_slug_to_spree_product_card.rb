class AddSlugToSpreeProductCard < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_product_cards, :slug, :string
  end
end

# touched on 2025-05-22T21:57:34.252688Z
# touched on 2025-05-22T23:27:19.631525Z
# touched on 2025-06-13T21:15:53.607139Z
# touched on 2025-06-13T21:16:23.668564Z