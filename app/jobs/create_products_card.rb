class CreateProductsCard < ApplicationJob
  queue_as :default

  def perform
    Spree::Product.all.each do |product|
      product.create_or_update_product_card
    end
  end
end

# touched on 2025-05-22T20:37:28.663992Z
# touched on 2025-05-22T23:06:51.179537Z
# touched on 2025-05-22T23:07:39.175790Z
