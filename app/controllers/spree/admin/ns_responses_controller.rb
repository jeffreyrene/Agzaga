module Spree
  class Admin::NsResponsesController < Spree::Admin::BaseController

    def index
      @responses = NsResponse.all.order(id: :desc).page(params.dig(:page) || 1 ).per(30)
    end

  end
end

# touched on 2025-05-22T20:44:19.120692Z
# touched on 2025-05-22T22:44:13.287419Z
# touched on 2025-05-22T23:41:44.780083Z
