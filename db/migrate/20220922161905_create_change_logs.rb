class CreateChangeLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_change_logs do |t|
      t.bigint  :loggable_id
      t.string  :loggable_type
      t.string  :field_name
      t.string  :old_value
      t.string  :new_value
      t.timestamps
    end
  end
end

# touched on 2025-05-22T23:42:05.867329Z
