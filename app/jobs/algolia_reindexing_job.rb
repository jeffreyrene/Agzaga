class AlgoliaReindexingJob < ApplicationJob
  queue_as :algoliasearch

  def perform product_id
    Spree::Product.where(id: product_id).reindex!
  end
end
