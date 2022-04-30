module Products::ProductFilters
  extend ActiveSupport::Concern

  def load_products
    search_query = params[:keywords].present? ? params[:keywords] : ''

    if params[:category].present?
      @products = Spree::Product.available.where(id: Spree::Product.algolia_search(search_query, {facetFilters: [[params[:category]]]}).pluck(:id))
    elsif search_query.present? && params[:optional].present?
      @products = Spree::Product.available.where(id: Spree::Product.algolia_search(search_query, { optionalWords: search_query}).pluck(:id))
    elsif search_query.present?
      ids = Spree::Product.algolia_search(search_query).pluck(:id)

      @products = Spree::Product.available.where(id: ids)
      @products = @products.order_as_specified(id: ids) if params[:order_by].blank?
    else
      @products = Spree::Product.available
    end

    @products = @products.exclude_custom_products
    @staff_pick_products = Spree::Product.deal_prodcuts('Staff Pick') unless @products.present?
    @taxonomies = Spree::Taxonomy.where(visibility: true).includes(root: :children)

    option_filter   if params[:option_filters].present? || params[:product_filters].present?
    category_filter if params[:category_filter].present?
    new_addition if params[:new_addition].present?
    featured_products if params[:featured_products].present?
    best_seller_products if params[:best_seller_products].present?
    ffa_products if params[:ffa_products].present?
    sort_products   if params[:order_by].present?
    @products = Kaminari.paginate_array(@products.uniq).page(params.dig(:page) || 1 ).per(30)
  end

  def sort_products_by_price(tag)
    case params[:filter_by_price]
    when 'Any - Price'
      @products.reorder('').send(:descend_by_master_price)
    when 'Under - $25'
      @price = 0.2555e2
      sort_by_less_price
    when '$200+'
      @price = 2.000e2
      sort_by_greater_price
    when '$25 - $50'
      @lower_price = 0.2555e2
      @higer_price = 0.5000e2
      sort_deals_products
    when '$50 - $100'
      @lower_price = 0.5000e2
      @higer_price = 1.0000e2
      sort_deals_products
    when '$100 - $200'
      @lower_price = 1.0000e2
      @higer_price = 2.0000e2
      sort_deals_products
    else
      []
    end
  end

  def filter_by_sale_price
    case params[:filter_by_price]
    when 'under_25'
      @products = @products.where("calculated_price < (?)", 0.2555e2)
    when '200+'
      @products = @products.where("calculated_price > (?)", 2.000e2)
    when '25-50'
      @products = @products.where("calculated_price BETWEEN ? AND ?", 0.2555e2, 0.5000e2)
    when '50-100'
      @products = @products.where("calculated_price BETWEEN ? AND ?", 0.5000e2, 1.0000e2)
    when '100-200'
      @products = @products.where("calculated_price BETWEEN ? AND ?", 1.0000e2, 2.0000e2)
    end
  end

  private

  def option_filter
    option_selection_ids =  params[:option_filters].present? ?
                              Spree::Product.joins(variants: :option_values)
                                .where('spree_option_values.id IN (?)', params.dig(:option_filters))
                                  .pluck(:id).uniq : []

    filter_selection_ids =  params[:product_filters].present? ?
                             Spree::Product.joins(:filter_values)
                                .where('spree_filter_values.id IN (?)', params.dig(:product_filters))
                                  .pluck(:id).uniq : []

    @products = @products.where(id: (option_selection_ids | filter_selection_ids))
  end

  def category_filter
    ids = @products.joins(taxons: :taxonomy).where("spree_taxonomies.id IN (?)", params.dig(:category_filter))
    @products = @products.where(id: ids)

    products_ids = Spree::Product.joins(taxons: :taxonomy)
                                    .where('spree_taxonomies.id IN (?)', params.dig(:category_filter))
                                      .uniq.pluck(:id)

    @option_types =  Spree::OptionType.joins(:products).includes(:option_values)
                                        .where('spree_products.id IN (?) AND spree_option_types.show_as_filter = TRUE', products_ids).uniq

    @filter_types = Spree::FilterType.joins(:products).includes(:filter_values)
                              .where('spree_products.id IN (?)', products_ids).uniq
  end

  def sort_products
    @products = order_products
  end

  def featured_products
    @products = @products.featured_products
  end

  def best_seller_products
    @products = @products.best_sellers
  end

  def ffa_products
    @products = @products.ffa_products
  end

  def new_addition
    @products = @products.available.newest_products
  end

  def order_products
    @products = Spree::Product.where(id: @products.map(&:id))
    case params[:order_by]
    when 'Price: Low to High'
      @products = @products.includes(:product_card).order("product_card.price asc")
    when 'Price: High to Low'
      @products = @products.includes(:product_card).order("product_card.price desc")
    when 'Staff Pick'
      @products = @products.staff_pick_sort
    when 'Sale'
      @products = @products.sale_products_sort
    when 'Best Sellers'
      @products = @products.best_sellers_sort
    else
      @products.none
    end
  end

  def sort_deals_products
    @products.sort_by_price_with_range(@lower_price, @higer_price)
  end

  def sort_by_greater_price
    @products.sort_by_greater_than_price(@price)
  end

  def sort_by_less_price
    @products.sort_by_price(@price)
  end
end
