module Spree
  class Admin::EbayChangeLogsController < Spree::Admin::BaseController

    def index
      @ebay_change_logs = Spree::EbayChangeLog.all.order(id: :desc).page(params.dig(:page) || 1 ).per(30)
    end
  end
end

# touched on 2025-05-22T20:39:45.503021Z
# touched on 2025-05-22T20:40:36.335794Z
