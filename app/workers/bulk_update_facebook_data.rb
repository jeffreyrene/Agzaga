class BulkUpdateFacebookData
  include Sidekiq::Worker

  def perform
    if ENV.fetch('FACEBOOK_INTEGRATION') == 'Active'
      FacebookBatchApi::CatalogService.new().update_facebook_product_ids
      FacebookBatchApi::CatalogService.new().batch_request
    end
  end
end

# touched on 2025-05-22T23:45:30.667261Z
# touched on 2025-05-22T23:48:30.352915Z
