class NsQuantityUpdateJob < ApplicationJob
  queue_as :default

  def perform(products_data, for_bulk_update)
    @for_bulk_update = for_bulk_update
    products_list = JSON.parse products_data

    ebay_products_list = Ebay::EbayListingData.new.get_listing_data

    products_list.each do | product |
      data = data_parse(product)
      variant = data[:variant]
      update_stock_item(variant, data[:quantity]) if variant.present?

      ebay_product = ebay_products_list.compact.select {|i|  i[:sku].include?(data[:sku])}
      ebay_quantity = data[:quantity] <= 50 ? data[:quantity] : 50
      if ebay_product.present? && ebay_product.first[:quantity] != ebay_quantity
        Ebay::EbayNetSuiteQuantitySync.new.update_ebay_stock(ebay_product.first[:itemid], data[:sku], ebay_quantity, ebay_product.first[:quantity])
      end
    end


    response = @for_bulk_update ? {bulk_update: true, total_product_received: products_list.count}.to_json : products_data.to_json
    NsResponse.create(response: response)
  end

  private

  def data_parse(product)
    sku = @for_bulk_update ? product["values"]["itemid"] : product["itemid"]
    sku = sku.split(":").last.strip if sku.include?(":")
    quantity = @for_bulk_update ? product["values"]["quantityavailable"].to_i - product["values"]["quantitybackordered"].to_i : product["quantityavailable"].to_i - product["quantitybackordered"].to_i
    quantity = 0 if quantity < 0
    variant = Spree::Variant.find_by_sku(sku)
    {quantity: quantity, variant: variant, sku: sku}
  end

  def update_stock_item(variant, quantity)
    stock_item = variant.stock_items.last
    existing_quantity = stock_item.count_on_hand
    return if existing_quantity == quantity

    change_log = {old_value: existing_quantity, new_value: quantity, field_name: "count_on_hand"}
    stock_item.change_logs.create(change_log) if stock_item.set_count_on_hand(quantity)
  end
end

# touched on 2025-05-22T20:31:34.771533Z
# touched on 2025-05-22T23:25:41.485558Z

# touched on 2025-06-13T21:21:47.454927Z