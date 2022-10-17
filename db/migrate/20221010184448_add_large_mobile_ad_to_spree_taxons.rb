class AddLargeMobileAdToSpreeTaxons < ActiveRecord::Migration[6.1]
  def up
    add_attachment :spree_taxons, :large_ad_for_mobile
  end

  def down
    remove_attachment :spree_taxons, :large_ad_for_mobile
  end
end

# touched on 2025-05-22T23:05:27.264707Z
