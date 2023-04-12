class CreateSpreeHomePageReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_home_page_reviews do |t|
      t.string :name
      t.integer :rating
      t.text :title
      t.text :comment
      t.integer :position
      t.boolean :visibility
      t.datetime :review_date

      t.timestamps
    end
  end
end

# touched on 2025-05-22T22:45:03.951393Z
# touched on 2025-05-22T23:18:41.207311Z
# touched on 2025-05-22T23:23:52.257833Z
# touched on 2025-05-22T23:48:02.604764Z
