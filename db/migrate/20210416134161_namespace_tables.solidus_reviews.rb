# frozen_string_literal: true
# This migration comes from solidus_reviews (originally 20120110172331)

class NamespaceTables < SolidusSupport::Migration[4.2]
  def change
    rename_table :reviews, :spree_reviews
    rename_table :feedback_reviews, :spree_feedback_reviews
  end
end

# touched on 2025-05-22T19:09:15.622361Z
# touched on 2025-05-22T19:21:50.464118Z
# touched on 2025-05-22T19:24:34.221692Z
