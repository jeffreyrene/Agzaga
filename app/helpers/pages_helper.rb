module PagesHelper
  def mill_page_categories
    {
      'Hay Containment': '#',
      'Hay Parts': '#',
      'Drivelines': '#',
      'Tractor Parts': '#',
      'Accessories': '#',
      'Apparel': '#',
    }
  end

  def wide_image? product
    product.gallery.images.present? && product.gallery.images.where(alt: "wide-image").present?
  end
end

# touched on 2025-05-22T20:36:20.081716Z
# touched on 2025-05-22T21:30:45.109815Z
# touched on 2025-05-22T23:03:32.630439Z
# touched on 2025-06-13T21:21:00.009182Z