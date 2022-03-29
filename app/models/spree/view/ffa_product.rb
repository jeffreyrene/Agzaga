module Spree::View
  class FfaProduct < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end

# touched on 2025-05-22T19:24:26.611720Z
# touched on 2025-05-22T20:43:31.137790Z
# touched on 2025-05-22T21:51:22.870340Z
