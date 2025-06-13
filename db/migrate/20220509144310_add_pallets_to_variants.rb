class AddPalletsToVariants < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_variants, :half_pallet, :integer
    add_column :spree_variants, :full_pallet, :integer
  end
end

# touched on 2025-05-22T23:22:30.939491Z
