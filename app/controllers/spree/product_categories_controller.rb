module Spree
  class ProductCategoriesController < Spree::StoreController
    helper Spree::BaseHelper
    helper Spree::ProductsHelper
    include Products::Cards

    def index
      @taxonomies = Spree::Taxonomy.where(visibility: true).includes(root: :children)
      @products = Kaminari.paginate_array(Spree::Product.available.newest_products.exclude_custom_products.limit(128)).page(params.dig(:page) || 1 ).per(16)
      load_product_cards(@products)

      respond_to do |format|
        format.js
        format.html
      end
    end
  end
end

# touched on 2025-05-22T19:10:39.307399Z
# touched on 2025-05-22T22:37:09.107508Z
# touched on 2025-06-13T21:15:50.440515Z