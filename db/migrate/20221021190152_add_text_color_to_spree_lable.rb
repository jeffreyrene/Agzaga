class AddTextColorToSpreeLable < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_labels, :display_text_color, :string
  end
end

# touched on 2025-05-22T23:03:29.956818Z

# touched on 2025-06-13T21:18:07.772573Z