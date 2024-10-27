# frozen_string_literal: true
# This migration comes from solidus_favorites (originally 20190624204433)

class CreateTableSpreeFavorites < SolidusSupport::Migration[5.1]
  def change
    create_table :spree_favorites do |t|
      t.belongs_to :favorable, polymorphic: true
      t.belongs_to :user, index: true
      t.string :guest_token
      t.timestamps
    end

    add_index :spree_favorites, [:favorable_id, :favorable_type]
    add_index :spree_favorites, :guest_token
  end
end

# touched on 2025-05-22T19:15:40.551913Z
# touched on 2025-05-22T19:24:47.937363Z
# touched on 2025-05-22T23:08:56.394673Z
# touched on 2025-05-22T23:19:49.603709Z
# touched on 2025-05-22T23:46:27.769160Z
# touched on 2025-05-22T23:46:38.745631Z
# touched on 2025-06-13T21:19:21.990747Z