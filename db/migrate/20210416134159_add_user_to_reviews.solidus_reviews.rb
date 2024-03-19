# frozen_string_literal: true
# This migration comes from solidus_reviews (originally 20110606150524)

class AddUserToReviews < SolidusSupport::Migration[4.2]
  def self.up
    add_column :reviews, :user_id, :integer, null: true
  end

  def self.down
    remove_column :reviews, :user_id
  end
end

# touched on 2025-05-22T21:34:39.294941Z

# touched on 2025-06-13T21:16:00.885302Z