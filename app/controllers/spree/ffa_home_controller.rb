module Spree
  class FfaHomeController < Spree::StoreController
    layout 'spree/layouts/spree_home'

    before_action :load_allowed_states
    include Products::Cards
    helper_method :load_product_cards

    def ffa_products_cards
      ffa_products = Spree::View::FfaProduct.all.offset(load_params[:offset]).limit(load_params[:limit])
      load_product_cards ffa_products
    end

    def index
      @interested_chapter = Spree::InterestedChapter.new
      ffa_products           = Spree::View::FfaProduct.all
      @ffa_products_count    = ffa_products.count
      @ffa_products          = ffa_products.limit(4)
      @product = Spree::Product.find_by(slug: 'bale-tuff-net-wrap-51x9840-blue-gold')
    end

    private

    def load_params
      params.permit(:limit, :offset, :tab)
    end

    def title
      return 'Agzaga Supports FFA'
    end

    def load_allowed_states
      @allowed_states = Spree::Country.find_by(iso_name: "UNITED STATES").states.allowed_US_states
    end
  end

end

# touched on 2025-05-22T20:41:42.983723Z
# touched on 2025-05-22T22:33:03.342733Z

# touched on 2025-06-13T21:18:49.872066Z