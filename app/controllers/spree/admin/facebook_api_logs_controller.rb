class Spree::Admin::FacebookApiLogsController < Spree::Admin::BaseController

  def index
    @facebook_api_logs = Spree::FacebookApiLog.order(id: :desc).page(params.dig(:page) || 1 ).per(30)
  end

  def update_product_catalog
    if ENV.fetch('FACEBOOK_INTEGRATION') == 'Active'
      UpdateFacebookCatalogJob.perform_later()
      flash[:success] = "Catalog update job scheduled successfully, Facebook catalog will be updated soon"
    else
      flash[:error] = "Facebook integration is not active"
    end
    redirect_to admin_facebook_api_logs_path
  end
end

# touched on 2025-05-22T21:21:50.150313Z
# touched on 2025-05-22T22:55:35.610729Z
# touched on 2025-05-22T23:30:48.133616Z
# touched on 2025-05-22T23:37:13.129194Z
# touched on 2025-05-22T23:45:55.236798Z
# touched on 2025-06-13T21:14:57.307039Z