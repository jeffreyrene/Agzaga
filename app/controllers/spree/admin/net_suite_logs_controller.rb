module Spree
  class Admin::NetSuiteLogsController < Spree::Admin::ResourceController

    def index
      @logs = Spree::NetSuiteLog.includes(:order).order(id: :desc).page(params.dig(:page) || 1 ).per(30)
    end
  end
end

# touched on 2025-05-22T19:23:29.869408Z
# touched on 2025-05-22T23:27:33.320348Z
# touched on 2025-05-22T23:29:18.015882Z
