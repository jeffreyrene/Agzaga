module Spree
  class Admin::ChangeLogsController < Spree::Admin::BaseController

    def index
      @change_logs = Spree::ChangeLog.all.order(id: :desc).page(params.dig(:page) || 1 ).per(30)
    end

  end
end

# touched on 2025-05-22T23:04:39.326489Z
# touched on 2025-05-22T23:10:05.017917Z
# touched on 2025-05-22T23:19:06.363747Z
