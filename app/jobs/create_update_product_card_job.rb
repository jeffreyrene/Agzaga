class CreateUpdateProductCardJob < ApplicationJob
  queue_as :productcard

  def perform product_id
    Spree::Product.find(product_id).create_or_update_product_card
  end
end

# touched on 2025-05-22T21:21:50.155708Z
# touched on 2025-05-22T22:46:42.310983Z
# touched on 2025-05-22T23:37:55.188366Z
# touched on 2025-05-22T23:46:48.668997Z
