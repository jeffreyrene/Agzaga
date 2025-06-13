class CreateCusotmHoseConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_hose_configurations do |t|
      t.integer :custom_hose_id
      t.integer :fitting_1_id
      t.integer :fitting_2_id
      t.integer :length
      t.references :order, null: false, index: true
      t.timestamps
    end
  end
end

# touched on 2025-05-22T20:44:54.116074Z
# touched on 2025-05-22T23:42:49.044693Z
