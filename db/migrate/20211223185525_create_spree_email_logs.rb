class CreateSpreeEmailLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_email_logs do |t|
      t.string :template_name
      t.string :subject
      t.string :sent_from
      t.string :sent_to
      t.string :status
      t.string :reject_reason
      t.references :order, null: false

      t.timestamps
    end
  end
end

# touched on 2025-05-22T19:09:23.014513Z
# touched on 2025-05-22T23:27:41.065706Z
# touched on 2025-05-22T23:30:48.134318Z
