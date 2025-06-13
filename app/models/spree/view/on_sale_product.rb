module Spree::View
  class OnSaleProduct < ApplicationRecord
    self.primary_key = :id


    def read_only?
      true
    end
  end
end

# touched on 2025-05-22T19:15:03.269756Z
# touched on 2025-05-22T19:15:08.362454Z
# touched on 2025-05-22T23:05:27.272738Z
