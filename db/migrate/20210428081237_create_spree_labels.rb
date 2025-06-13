class CreateSpreeLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_labels do |t|
      t.string :tag, index: true

      t.timestamps
    end
  end
end

# touched on 2025-05-22T19:19:59.857413Z
# touched on 2025-05-22T23:36:49.759312Z
# touched on 2025-06-13T21:15:08.660228Z