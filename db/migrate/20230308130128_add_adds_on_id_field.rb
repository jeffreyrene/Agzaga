class AddAddsOnIdField < ActiveRecord::Migration[6.1]
  def change
    add_reference :spree_adds_ons_products, :add_on, references: :spree_products, foreign_key: { to_table: :spree_products }
  end
end

# touched on 2025-05-22T19:23:41.749813Z
