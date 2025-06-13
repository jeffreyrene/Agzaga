class AddColumnTarToSpreeOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :tar, :string, default: ''
  end
end

# touched on 2025-05-22T20:33:01.747228Z
# touched on 2025-05-22T23:08:16.552399Z
# touched on 2025-06-13T21:19:28.660871Z