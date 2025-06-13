class AddColorToSpreeLable < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_labels, :color, :string
  end
end

# touched on 2025-05-22T23:25:41.487425Z
# touched on 2025-05-22T23:30:36.973891Z
