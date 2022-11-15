# frozen_string_literal: true

module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    before_action :load_page_data, only: :index_v2
    include Products::Cards
    helper_method :load_product_cards

    def index
      @featured_products = Spree::Product.featured_products
      @taxonomies = Spree::Taxonomy.where(visibility: true).includes(root: :children)
    end

    def index_v2
      @home_page_cta = Spree::CtaImage.all.where('(spree_cta_images.start_at <= ? AND spree_cta_images.end_at >= ?)', Time.now, Time.now ).order(:position)
      @taxonmies = Spree::Taxonomy.all.where(visibility: true)
      render layout: 'spree/layouts/spree_home'
    end

    def featured_products_cards
      featured_products = Spree::View::FeaturedProduct.all.offset(load_params[:offset]).limit(load_params[:limit])
      load_product_cards featured_products
    end

    def best_seller_products_cards
      best_seller_ids = Spree::View::BestSellerProduct.all.pluck("id").uniq
      best_seller = Spree::Product.where(id: best_seller_ids).index_by(&:id).extract!(*best_seller_ids).values.drop(load_params[:offset].to_i).first(load_params[:limit].to_i)
      load_product_cards best_seller
    end

    def site_wide_products_cards
      site_wide_products = Spree::View::SiteWideDeal.all.offset(load_params[:offset]).limit(load_params[:limit])
      load_product_cards site_wide_products
    end

    def recently_viewed_products_cards
      recently_viewed = Spree::Product.exclude_custom_products.where(id: session[:recently_viewed_products]&.uniq).offset(load_params[:offset]).limit(load_params[:limit].to_i)
      load_product_cards recently_viewed
    end

    private

    def load_params
      params.permit(:limit, :offset, :tab)
    end

    def load_page_data
      @categories                 = Spree::Taxonomy.where(visibility: true).first(5)
      featured_products           = Spree::View::FeaturedProduct.all
      @featured_products_count    = featured_products.count
      @featured_products          = featured_products.limit(4)

      @new_arrivals               = Spree::Product.available.newest_products.exclude_custom_products.in_stock.first(4)
      site_wide_deals             = Spree::View::SiteWideDeal.all
      @site_wide_products_count   = site_wide_deals.count
      @site_wide_deals            = site_wide_deals.limit(4)

      @start_young_products       = Spree::View::StartYoungProduct.limit(4)
      @make_easy_products         = Spree::Product.where(id: Spree::View::MakeEasyProduct.last(2).pluck(:id))

      best_seller_ids             = Spree::View::BestSellerProduct.all.pluck("id").uniq
      best_seller                 = Spree::Product.where(id: best_seller_ids).index_by(&:id).extract!(*best_seller_ids).values
      @best_seller_products_count = best_seller.count
      @best_seller                = best_seller.first(4)

      recently_viewed             = Spree::Product.exclude_custom_products.where(id: session[:recently_viewed_products]&.uniq) if spree_user_signed_in?
      @recently_viewed_products_count = recently_viewed.count if spree_user_signed_in?
      @recently_viewed            = recently_viewed.limit(4) if spree_user_signed_in?

      @cutomer_reviews            = Spree::HomePageReview.where(visibility: true).order('position asc')
    end
  end
end

# touched on 2025-05-22T19:24:47.939194Z
# touched on 2025-05-22T22:32:45.259575Z
