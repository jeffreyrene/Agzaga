class CreateFfaChapter < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_ffa_chapters do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :name
      t.integer :members
      t.string :number
      t.string :ein_number
      t.string :school_name
      t.string :street
      t.string :city
      t.string :state
      t.integer :postal_code
      t.string :digital_signature
      t.boolean :consent_verified
      t.string :status
      t.timestamps
    end
  end
end

# touched on 2025-05-22T19:22:39.717100Z
# touched on 2025-05-22T20:39:06.154234Z
# touched on 2025-05-22T22:29:10.993184Z
# touched on 2025-05-22T23:36:49.763363Z
