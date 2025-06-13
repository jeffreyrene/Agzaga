class AddColumnReferenceToSpreeOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :ref, :string, default: ''
  end
end

# touched on 2025-05-22T20:45:04.828127Z
# touched on 2025-05-22T23:39:03.396575Z
# touched on 2025-05-22T23:45:49.856206Z
# touched on 2025-06-13T21:21:47.449017Z