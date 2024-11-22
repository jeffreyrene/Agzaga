# frozen_string_literal: true
# This migration comes from spree (originally 20170223235001)

class RemoveSpreeStoreCreditsColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :spree_store_credits, :spree_store_credits, :datetime
  end
end

# touched on 2025-05-22T21:51:28.223158Z
# touched on 2025-05-22T23:39:34.425558Z

# touched on 2025-06-13T21:19:44.320669Z