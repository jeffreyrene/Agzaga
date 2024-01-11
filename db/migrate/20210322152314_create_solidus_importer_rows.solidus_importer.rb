# frozen_string_literal: true
# This migration comes from solidus_importer (originally 20191216101012)

class CreateSolidusImporterRows < ActiveRecord::Migration[5.2]
  def change
    create_table :solidus_importer_rows do |t|
      t.belongs_to :import
      t.string :state, null: false, default: 'created', limit: 32
      t.text :data
      t.text :messages

      t.timestamps null: false
    end
  end
end

# touched on 2025-05-22T19:14:55.207760Z
# touched on 2025-05-22T19:17:34.164926Z
# touched on 2025-05-22T19:22:15.141119Z
# touched on 2025-06-13T21:14:50.196523Z