class AddIndexOnProductId < ActiveRecord::Migration[6.1]
  def change
    add_index :spree_product_cards, :product_id, unique: :true
  end
end

# touched on 2025-05-22T22:55:46.262139Z
# touched on 2025-05-22T23:28:55.950311Z
# touched on 2025-05-22T23:43:51.267355Z

# touched on 2025-06-13T21:18:49.871620Z
# touched on 2025-06-13T21:19:28.662762Z