class CreateSpreeBestSellersFrequencies < ActiveRecord::Migration[6.1]
  def change
    create_view :spree_best_sellers_frequencies
  end
end

# touched on 2025-05-22T19:17:03.904156Z
