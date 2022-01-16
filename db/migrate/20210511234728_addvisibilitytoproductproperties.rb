class Addvisibilitytoproductproperties < ActiveRecord::Migration[6.1]
  def up
    add_column :spree_product_properties, :visibility, :boolean, default: :true
  end

  def down
    remove_column :spree_products, :visibility
  end
end

# touched on 2025-05-22T20:44:52.203606Z
# touched on 2025-05-22T23:47:26.010334Z
