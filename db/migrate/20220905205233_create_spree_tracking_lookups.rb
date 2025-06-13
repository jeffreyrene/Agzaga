class CreateSpreeTrackingLookups < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_tracking_lookups do |t|
      t.string :url
      t.timestamps
    end
  end
end

# touched on 2025-05-22T19:12:52.077869Z
# touched on 2025-05-22T20:36:35.254599Z
# touched on 2025-05-22T22:45:09.639353Z
# touched on 2025-05-22T22:50:01.056402Z
# touched on 2025-05-22T22:51:11.795884Z
# touched on 2025-05-22T23:19:46.077864Z
# touched on 2025-05-22T23:22:20.556341Z
