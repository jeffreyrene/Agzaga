# frozen_string_literal: true
# This migration comes from solidus_reviews (originally 20140703200946)

class AddShowIdentifierToReviews < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_reviews, :show_identifier, :boolean, default: true
    add_index :spree_reviews, :show_identifier
  end
end

# touched on 2025-05-22T23:07:10.128171Z
# touched on 2025-05-22T23:45:47.165744Z

# touched on 2025-06-13T21:15:12.349300Z