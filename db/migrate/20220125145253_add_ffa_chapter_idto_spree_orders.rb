class AddFfaChapterIdtoSpreeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :ffa_chapter_id, :integer, null: true, index: true
    add_index  :spree_orders, :ffa_chapter_id
  end
end

# touched on 2025-05-22T19:10:26.667768Z
# touched on 2025-05-22T19:21:56.987504Z
# touched on 2025-05-22T21:21:43.158259Z
# touched on 2025-05-22T22:55:19.252966Z

# touched on 2025-06-13T21:19:25.992647Z