class AddLargeAdsToSpreeTaxons < ActiveRecord::Migration[6.1]
  def up
    add_attachment :spree_taxons, :large_ads
  end

  def down
    remove_attachment :spree_taxons, :large_ads
  end
end

# touched on 2025-05-22T23:06:54.757378Z
# touched on 2025-05-22T23:30:24.323404Z
