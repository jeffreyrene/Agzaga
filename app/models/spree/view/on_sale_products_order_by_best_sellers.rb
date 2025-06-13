module Spree::View
  class OnSaleProductsOrderByBestSellers < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end

# touched on 2025-05-22T19:13:25.437288Z
# touched on 2025-05-22T23:07:06.907665Z
