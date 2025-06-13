class AddEmailToSpreeProductQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_product_questions, :email, :string
  end
end

# touched on 2025-05-22T22:55:21.884112Z
# touched on 2025-05-22T23:04:31.604989Z
# touched on 2025-05-22T23:27:41.061392Z
