class GoogleIndexingJob < ApplicationJob
  queue_as :default

  def perform product_slug, url_type
    Google::GoogleIndexingService.new.update_url_notification("https://agzaga.com/products/#{product_slug}", url_type)
  end
end

# touched on 2025-05-22T20:32:22.090331Z
# touched on 2025-05-22T20:38:19.620481Z
# touched on 2025-05-22T23:27:19.633983Z
# touched on 2025-05-22T23:42:40.730549Z
