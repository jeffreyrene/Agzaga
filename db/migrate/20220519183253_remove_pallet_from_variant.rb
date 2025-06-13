class RemovePalletFromVariant < ActiveRecord::Migration[6.1]
  def change
    remove_column :spree_variants, :half_pallet, :integer
    remove_column :spree_variants, :full_pallet, :integer
  end
end

# touched on 2025-05-22T23:24:18.282213Z
# touched on 2025-05-22T23:47:15.997407Z

# touched on 2025-06-13T21:21:53.299886Z