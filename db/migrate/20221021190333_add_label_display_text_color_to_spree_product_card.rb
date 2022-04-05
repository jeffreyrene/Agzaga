class AddLabelDisplayTextColorToSpreeProductCard < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_product_cards, :label_display_text_color, :string
    add_column :spree_product_cards, :in_stock, :boolean
    add_column :spree_product_cards, :discount_percentage, :decimal
  end
end

# touched on 2025-05-22T19:21:52.874530Z
# touched on 2025-05-22T20:41:10.642870Z
# touched on 2025-05-22T23:47:10.572306Z
