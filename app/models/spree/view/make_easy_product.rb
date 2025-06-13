module Spree::View
  class MakeEasyProduct < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end

# touched on 2025-05-22T20:41:10.649930Z
# touched on 2025-05-22T23:30:34.151268Z
# touched on 2025-05-22T23:48:28.045137Z
