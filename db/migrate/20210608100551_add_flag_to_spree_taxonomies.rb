class AddFlagToSpreeTaxonomies < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_taxonomies, :visibility, :boolean, default: true
  end
end

# touched on 2025-05-22T19:17:29.025041Z
# touched on 2025-05-22T19:22:05.375013Z
# touched on 2025-05-22T19:24:31.448523Z
# touched on 2025-05-22T20:37:28.668544Z
# touched on 2025-05-22T20:37:55.532011Z
# touched on 2025-05-22T20:38:24.234330Z
