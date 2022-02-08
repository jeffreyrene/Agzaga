class AddSmallMobileAdToSpreeTaxons < ActiveRecord::Migration[6.1]
  def up
    add_attachment :spree_taxons, :small_ad_for_mobile
  end

  def down
    remove_attachment :spree_taxons, :small_ad_for_mobile
  end
end

# touched on 2025-05-22T19:17:29.029346Z
# touched on 2025-05-22T23:26:26.189591Z
