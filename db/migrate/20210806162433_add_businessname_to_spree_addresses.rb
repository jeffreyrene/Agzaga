class AddBusinessnameToSpreeAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_addresses, :businessname, :string
  end
end

# touched on 2025-05-22T20:45:04.832434Z
# touched on 2025-05-22T23:30:28.997207Z
# touched on 2025-06-13T21:15:15.899052Z