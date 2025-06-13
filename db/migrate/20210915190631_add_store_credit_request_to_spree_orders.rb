class AddStoreCreditRequestToSpreeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :store_credit_request, :decimal, precision: 10, scale: 2, default: "0.0"
  end
end

# touched on 2025-05-22T19:14:52.841010Z
# touched on 2025-05-22T20:37:41.524927Z
# touched on 2025-05-22T20:43:53.215219Z
