module ProductsHelper
  def product_out_of_stock(product)
    variants_stock = false
    variant_stock = product.variants.any?{ |v| v.can_supply? }
  end

  def out_of_stock(product, variants_stock)
    (!product.master.can_supply? && product.variants.empty? )  || (!product.variants.empty? && !product.master.can_supply? && !variants_stock)
  end

  def product_in_stock? product
    product_variants =  product.variants
    res = product_variants.present? ? product_variants.any?{ |v| v.can_supply? } : product.master.can_supply?
  end

  def mobile_image? product
    product.gallery.images.present? && product.gallery.images.where(alt: "mobile-image").present?
  end

  def product_label text, label_background_color='', label_display_text_color=''
    return unless text.present?
    if text.include?(',') && (text.split(',').length == 2)
      (content_tag :div, text.split(',')[0], class: "product-label-text product-label-text-top", style: "--label-color: #{label_background_color}; --label_display_text_color: #{label_display_text_color}") +
      (content_tag :div, text.split(',')[1], class: "product-label-text product-label-text-bottom", style: "--label-color: #{label_background_color}; --label_display_text_color: #{label_display_text_color}")
    else
      content_tag :div, text, class: "product-label-text product-label-text-#{text.include?("Ships Direct") ? "bottom" : "top" }", style: "--label-color: #{label_background_color}; --label_display_text_color: #{label_display_text_color}"
    end
  end

  def early_bird_modal_time
    return Time.now.in_time_zone('America/Chicago').between?(Time.rfc3339('2023-05-27 23:00:00-06:00').in_time_zone('America/Chicago'), Time.rfc3339('2023-05-31 22:59:00-06:00').in_time_zone('America/Chicago'))
  end

  def agzaga_day_modals
    return Time.now.in_time_zone('America/Chicago') > Time.rfc3339('2023-05-27 23:00:00-06:00').in_time_zone('America/Chicago')
  end
end
