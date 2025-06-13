module Spree::View
  class TaxonWithOnSaleProduct < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end

# touched on 2025-05-22T20:31:32.576530Z
# touched on 2025-05-22T20:38:43.744581Z
# touched on 2025-05-22T21:34:02.987347Z
# touched on 2025-05-22T23:42:21.017804Z
