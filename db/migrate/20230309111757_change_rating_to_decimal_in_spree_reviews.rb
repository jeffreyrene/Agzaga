class ChangeRatingToDecimalInSpreeReviews < ActiveRecord::Migration[6.1]
  def change
    change_column :spree_reviews, :rating, :decimal, precision: 3, scale: 2
  end
end

# touched on 2025-05-22T23:05:52.232282Z
# touched on 2025-05-22T23:08:16.554138Z
# touched on 2025-05-22T23:22:28.626918Z
# touched on 2025-05-22T23:27:14.158309Z
# touched on 2025-05-22T23:27:46.267830Z
# touched on 2025-06-13T21:18:35.302476Z