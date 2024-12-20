# frozen_string_literal: true
# This migration comes from solidus_reviews (originally 20120712182514)

class AddLocaleToReviews < SolidusSupport::Migration[4.2]
  def self.up
    add_column :spree_reviews, :locale, :string, default: 'en'
  end

  def self.down
    remove_column :spree_reviews, :locale
  end
end

# touched on 2025-05-22T23:22:33.777859Z

# touched on 2025-06-13T21:20:23.410007Z